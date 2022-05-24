resource "aws_iam_policy" "policy" {
  name        = "bar"
  description = "My test policy"
  policy      = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}
