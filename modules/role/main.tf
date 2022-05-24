resource "aws_iam_role" "role" {
  name                 = var.name
  description          = var.description
  max_session_duration = var.max_session_duration
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns  = var.managed_policy_arns
  tags                 = var.tags

  dynamic "inline_policy" {
    # create inline policy only if statements specified
    for_each = length(var.statements) > 0 ? [1] : []

    content {
      name   = "${var.name}_policy"
      policy = data.aws_iam_policy_document.inline_policy.json
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    dynamic "principals" {
      for_each = var.assume_role_principals

      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "inline_policy" {
  dynamic "statement" {
    for_each = var.statements

    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "condition" {
        # check if conditon block is specified using a splat expression
        for_each = try(statement.value.condition[*], [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
