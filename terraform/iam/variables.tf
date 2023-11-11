variable "application" {
  type        = string
  description = "A business context to aggregate several resources within the same grouping"
}

variable "cloudfront_distribution_arns" {
  type        = list(string)
  description = "CloudFront Distributions ARNs"
}

variable "bucket_arns" {
  type        = list(string)
  description = "S3 Buckets ARNs"
}

variable "tags" {
  type        = map(string)
  description = "Tags for managed resources"
}
