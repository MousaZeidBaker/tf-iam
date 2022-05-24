data "aws_caller_identity" "current" {}

module "role" {
  source = "../../../modules/role"

  name                 = "bar"
  description          = "The bar role"
  max_session_duration = 3600

  assume_role_principals = [
    {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/bar",
      ]
    },
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]

  statements = [
    {
      effect    = "Deny"
      actions   = ["dynamodb:*"]
      resources = ["*"]
    },
    {
      effect    = "Allow"
      actions   = ["s3:ListBucket"]
      resources = ["*"]
      condition = {
        test     = "StringLike"
        variable = "s3:prefix"
        values   = ["home/"]
      }
    },
  ]

  tags = { "name" : "bar" }
}
