data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_policy" "poweruser_policy" {
  name   = "${var.application}-${terraform.workspace}-CloudFrontS3PowerUserAccessPolicy"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:CreateKey",
                "cloudfront:CreateOriginAccessControl",
                "cloudfront:CreateDistributionWithTags"
            ],
            "Resource": "*",
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
                "kms:DescribeKey",
                "kms:GetKeyPolicy",
                "kms:GetKeyRotationStatus",
                "kms:ListResourceTags",
                "kms:PutKeyPolicy",
                "kms:ScheduleKeyDeletion"
            ],
            "Resource": "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*",
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
                "cloudfront:GetOriginAccessControl",
                "cloudfront:DeleteOriginAccessControl"
            ],
            "Resource": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:origin-access-control/*",
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
                "kms:DescribeKey"
            ],
            "Resource": "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/alias/aws/s3",
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
                "cloudfront:GetDistribution",
                "cloudfront:ListTagsForResource",
                "cloudfront:UpdateDistribution",
                "cloudfront:DeleteDistribution"
            ],
            "Resource": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/application": "${var.application}",
                    "aws:ResourceTag/environment": "${terraform.workspace}"
                }
            }
        }
    ]
}
EOT

  tags = var.tags
}
