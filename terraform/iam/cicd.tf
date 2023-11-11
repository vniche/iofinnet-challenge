locals {
  distributions_arn    = join("\",\"", var.cloudfront_distribution_arns)
  buckets_arns         = join("\",\"", var.bucket_arns)
  buckets_objects_arns = join("/*\",\"", var.bucket_arns)
}

resource "aws_iam_policy" "cicd_policy" {
  name   = "${var.application}-${terraform.workspace}-CloudFrontS3CICDPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateInvalidation"
            ],
            "Resource": ["${local.distributions_arn}"],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/application": "${var.application}",
                    "aws:ResourceTag/environment": "${terraform.workspace}"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": ["${local.buckets_objects_arns}/*"],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/application": "${var.application}",
                    "aws:ResourceTag/environment": "${terraform.workspace}"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": ["${local.buckets_arns}"],
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/application": "${var.application}",
                    "aws:ResourceTag/environment": "${terraform.workspace}"
                }
            }
        }
    ]
}
EOF

  tags = var.tags
}
