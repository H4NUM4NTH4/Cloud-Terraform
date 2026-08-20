terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

variable "environments" {
  type    = set(string)
  default = ["dev", "prod"]
}

resource "aws_s3_bucket" "app" {
  for_each = var.environments

  bucket = "h4num4nth4-app-${each.key}-2026"
}
