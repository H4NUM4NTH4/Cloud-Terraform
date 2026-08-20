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

variable "servers" {
  type = map(object({
    instance_type = string
    environment   = string
    monitoring    = bool
  }))

  default = {
    dev = {
      instance_type = "t3.micro"
      environment   = "dev"
      monitoring    = false
    }

    qa = {
      instance_type = "t3.micro"
      environment   = "qa"
      monitoring    = false
    }

    production = {
      instance_type = "t3.xlarge"
      environment   = "prod"
      monitoring    = true
    }
  }
}

resource "aws_s3_bucket" "server" {
  for_each = var.servers

  bucket = "h4num4nth4-server-${each.key}-2026"

  tags = {
    Environment  = each.value.environment
    InstanceType = each.value.instance_type
    Monitoring   = tostring(each.value.monitoring)
  }
}