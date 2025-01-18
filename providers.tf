terraform {
  required_version = "1.10.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-source"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-source"
  }
}

provider "aws" {
  region = "eu-north-1"
}

provider "archive" {
  # https://registry.terraform.io/providers/hashicorp/archive/latest/docshttps://registry.terraform.io/providers/hashicorp/archive/latest/docs
  # Empty
}