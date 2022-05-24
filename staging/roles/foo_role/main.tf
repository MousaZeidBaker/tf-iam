data "aws_caller_identity" "current" {}

module "role" {
  source = "../../../modules/role"

  name        = "foo"
  description = "The foo role"

  assume_role_principals = [
    {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/foo",
      ]
    },
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]
}
