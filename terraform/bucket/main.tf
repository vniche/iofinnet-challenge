resource "aws_s3_bucket" "bucket" {
  # uuid is used here because it has to be unique among buckets throughout the whole AWS
  bucket = "${var.bucket_name}-${var.uuid}-${terraform.workspace}"
  tags   = var.tags
}

resource "aws_s3_bucket_ownership_controls" "content_buckets_acl_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "buckets_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket.bucket, aws_s3_bucket_ownership_controls.content_buckets_acl_ownership]
}

resource "aws_s3_bucket_versioning" "buckets_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "encryption_key" {
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryption_key.id
      sse_algorithm     = "aws:kms"
    }
  }
}
