data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.project}-${var.env}-terraform-state-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project}-${var.env}-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/example-role"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.terraform_state.arn,
      "${aws_s3_bucket.terraform_state.arn}/*",
    ]
  }
}
