resource "aws_iam_user" "user" {
  name = "bar"
}

resource "aws_iam_user_policy" "policy" {
  user   = aws_iam_user.user.name
  name   = "${aws_iam_user.user.name}_policy"
  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}
