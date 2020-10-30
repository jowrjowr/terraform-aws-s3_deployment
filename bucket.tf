# object storage

# ACL reference:
# https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
resource "aws_s3_bucket" "bucket" {
  bucket = "company-${var.project}-${var.environment}-${var.name}"
  acl    = "private"

  tags = {
    Name        = var.name
    terraform   = "true"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "no_public" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
}
