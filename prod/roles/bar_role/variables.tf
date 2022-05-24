variable "project" {
  description = "The project name"
  type        = string
}

variable "env" {
  description = "The deployment environment (dev, staging, prod)"
  type        = string
}

variable "default_tags" {
  description = "Default tags"
  type        = map(any)
}
