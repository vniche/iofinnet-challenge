output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "encryption_key_id" {
  value = aws_kms_key.encryption_key.id
}
