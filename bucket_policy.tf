
# the s3 vpc endpoint is automatically created by the networking module(s)
# NOTE: region is hardcoded.

data "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.eu-west-1.s3"
}

# explicitly allow FULL read access to the bucket as a default minimum bucket policy.
# write access will be managed at a later time once it is necessary

data "aws_iam_policy_document" "read_only" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpce"
      values   = [data.aws_vpc_endpoint.s3.id]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
      aws_s3_bucket.bucket.arn,
    ]

    effect = "Allow"
  }
}

resource "aws_s3_bucket_policy" "read_only" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.read_only.json
}
