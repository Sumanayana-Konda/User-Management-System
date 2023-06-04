resource "aws_s3_bucket_server_side_encryption_configuration" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id
  rule {
    id     = "transition_to_standard_ia"
    status = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_s3_bucket" "private_bucket" {
  bucket        = "demo-tf-s3-sumanayana"
  force_destroy = true
}


resource "aws_s3_bucket_public_access_block" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id
  
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
