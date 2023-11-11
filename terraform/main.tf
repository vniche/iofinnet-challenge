// a random uuid is provided here to ensure that buckets are unique across all AWS systems
resource "random_uuid" "uuid" {}

locals {
  app_tags = {
    "application" : var.application
    "environment" : terraform.workspace
  }
}

module "buckets" {
  for_each = toset(var.buckets)

  source      = "./bucket"
  bucket_name = each.value
  uuid        = random_uuid.uuid.id

  tags = merge(var.tags, local.app_tags)
}

resource "aws_s3_object" "buckets_pages" {
  for_each = toset(var.buckets)

  bucket       = "${each.value}-${random_uuid.uuid.id}-${terraform.workspace}"
  key          = "${each.value}/index.html"
  content_type = "text/html"
  content      = <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>${each.value}</title>
</head>
<body>
  <header>
    <h1>${each.value}</h1>
  </header>
</body>
</html>
EOF

  tags = merge(var.tags, local.app_tags)

  depends_on = [module.buckets]
}

// origin access controll is managed here because it does not need to be created for each cloudfront instance
resource "aws_cloudfront_origin_access_control" "content_buckets_origin_acl" {
  name                              = "content-buckets-oac"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  origin_access_control_origin_type = "s3"
}

module "cloudfront_distributions" {
  for_each = toset(var.buckets)

  source                   = "./cloudfront"
  uuid                     = random_uuid.uuid.id
  default_root_object      = "${each.value}/index.html"
  bucket_id                = module.buckets[each.value].bucket_id
  origin_access_control_id = aws_cloudfront_origin_access_control.content_buckets_origin_acl.id
  bucket_encryption_key_id = module.buckets[each.value].encryption_key_id

  tags = merge(var.tags, local.app_tags)

  depends_on = [module.buckets, aws_s3_object.buckets_pages]
}

locals {
  bucket_arns = [
    for bucket in module.buckets :
    bucket.bucket_arn
  ]

  cloudfront_distribution_arns = [
    for distributions in module.cloudfront_distributions :
    distributions.cloudfront_distribution_arn
  ]
}

module "iam" {
  source                       = "./iam"
  bucket_arns                  = local.bucket_arns
  cloudfront_distribution_arns = local.cloudfront_distribution_arns
  application                  = var.application

  tags = merge(var.tags, local.app_tags)
}
