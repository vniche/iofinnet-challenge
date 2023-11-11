output "cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.cloudfront_distribution.arn
}
