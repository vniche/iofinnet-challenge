output "bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "encryption_key_id" {
  value = aws_kms_key.encryption_key.id
}