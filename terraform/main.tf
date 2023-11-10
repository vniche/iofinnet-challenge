terraform {
  # uncomment if you want to use s3 as backend for state management and persistent
  # backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = var.region
}

// a random uuid is provided here to ensure that buckets are unique acr
resource "random_uuid" "uuid" {}

module "buckets" {
  for_each = toset(var.buckets)

  source      = "./bucket"
  bucket_name = each.value
  uuid        = random_uuid.uuid.id
}

resource "aws_s3_object" "buckets_pages" {
  for_each = toset(var.buckets)

  bucket       = "${each.value}-${random_uuid.uuid.id}-${terraform.workspace}"
  key          = "${each.value}/index.html"
  content_type = "text/html"
  content      = <<EOT
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
EOT

  depends_on = [module.buckets]
}

// origin access controll is managed here because it does not need to be created for each cloudfront instance
resource "aws_cloudfront_origin_access_control" "content_buckets_origin_acl" {
  name                              = "content-buckets-oac"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  origin_access_control_origin_type = "s3"
}

module "cloudfront" {
  for_each = toset(var.buckets)

  source                   = "./cloudfront"
  uuid                     = random_uuid.uuid.id
  default_root_object      = "${each.value}/index.html"
  bucket_id                = module.buckets[each.value].bucket_id
  origin_access_control_id = aws_cloudfront_origin_access_control.content_buckets_origin_acl.id
  bucket_encryption_key_id = module.buckets[each.value].encryption_key_id

  depends_on = [module.buckets, aws_s3_object.buckets_pages]
}

output "cloudfront_urls" {
  value = module.cloudfront
}
