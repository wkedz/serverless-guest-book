terraform {
  required_version = "~> 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }
}