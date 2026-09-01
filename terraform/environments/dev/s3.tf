resource "aws_s3_bucket" "backend" {
  bucket = "${var.project_name}-s3-backend"

  tags = {
    Name = "${var.project_name}-${var.environment}-s3-backend"
  }
}

resource "aws_s3_bucket_ownership_controls" "backend" {
  bucket = aws_s3_bucket.backend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "backend_versioning" {
  bucket = aws_s3_bucket.backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "backend_encryption_key" {
  description = "This key is used to encrypt bucket objects"
  tags = {
    Name = "${var.project_name}-${var.environment}-kms-key"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_encryption" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.backend_encryption_key.arn
    }
  }
}