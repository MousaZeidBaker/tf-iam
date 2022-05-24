terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "tf-iam-staging-terraform-state"
    key            = "backend/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-iam-staging-terraform-state-lock"
  }
}
