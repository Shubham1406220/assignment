terraform {
  required_version = "0.13.0"
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"
    region = "var.aws_region"
  }
  required_providers {
    aws = {
      source  = "-/aws"
      version = "3.60"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}