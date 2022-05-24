variable "name" {
  description = "Name of the role"
  type        = string
}

variable "description" {
  description = "Description of the role"
  type        = string
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Invalid variable: \"max_session_duration\" must be in the interval 3600 - 43200."
  }
}

variable "assume_role_principals" {
  description = "A list of policy principals allowed to assume the role"
  type = list(object({
    type        = string
    identifiers = list(string)
  }))

  validation {
    condition = alltrue([
      for p in var.assume_role_principals : (
        contains(["AWS", "Service", "Federated", "CanonicalUser", "*"], p.type)
    )])
    error_message = "Invalid variable: \"type\" is required and valid values are \"AWS\", \"Service\", \"Federated\", \"CanonicalUser\" or \"*\"."
  }
}

variable "managed_policy_arns" {
  description = "A list of managed policy ARNs to attach to the role"
  type        = list(string)
}

variable "statements" {
  description = "A list of policy statements to add to the inline policy of the role"
  type        = any
  default     = []

  # validate effect
  validation {
    condition = alltrue([
      for s in var.statements : (
        try(contains(["Allow", "Deny"], s.effect), false)
    )])
    error_message = "Invalid variable: \"effect\" is required and valid values are \"Allow\" or \"Deny\"."
  }

  # validate actions
  validation {
    condition = alltrue([
      for s in var.statements : (
        try(!contains(s.actions, "*"), false)
    )])
    error_message = "Invalid variable: \"actions\" is required and standalone asterisk (*) wildcard is forbidden."
  }

  # validate condition
  validation {
    condition = alltrue([
      # loop through statements with condition block specified
      for s in [for s in var.statements : s if can(s.condition)] : (
        alltrue([
          can(s.condition.test),
          can(s.condition.variable),
          can(s.condition.values),
        ])
    )])
    error_message = "Invalid variable: \"condition\" must contain \"test\", \"variable\" & \"values\"."
  }
}

variable "tags" {
  description = "Tags for the role"
  type        = map(any)
  default     = {}
}
