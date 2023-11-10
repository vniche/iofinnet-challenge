

data "aws_region" "current" {}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name              = "${var.bucket_id}.s3.${data.aws_region.current.name}.amazonaws.com"
    origin_id                = var.bucket_id
    origin_access_control_id = var.origin_access_control_id
  }

  enabled             = true
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_id

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "cloudfront_bucket_policy" {
  bucket = var.bucket_id
  policy = jsonencode({
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Resource = "arn:aws:s3:::${var.bucket_id}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.cloudfront_distribution.arn}"
          }
        }
      },
    ]
    Version = "2012-10-17"
  })
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key_policy" "cloudfront_kms_policy" {
  key_id = var.bucket_encryption_key_id
  policy = jsonencode({
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "AWS" = "${data.aws_caller_identity.current.arn}"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*"
        ],
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Resource = "*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "${aws_cloudfront_distribution.cloudfront_distribution.arn}"
          }
        }
      },
    ]
    Version = "2012-10-17"
  })
}
