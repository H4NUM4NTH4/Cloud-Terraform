terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "h4num4nth4-terraform-state"
    key          = "count-hands-on/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

variable "environments" {
  type    = list(string)
  default = ["prod", "qa", "dev"]
}

resource "aws_s3_bucket" "app" {
  count = length(var.environments)

  bucket = "h4num4nth4-count-${count.index}-2026"
}