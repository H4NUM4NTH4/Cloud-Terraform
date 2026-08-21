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

variable "ingress_rules" {
  type = map(object({
    description = string
    port        = number
    cidr_blocks = list(string)
  }))

  default = {
    http = {
      description = "HTTP"
      port        = 80
      cidr_blocks = ["0.0.0.0/0"]
    }

    https = {
      description = "HTTPS"
      port        = 443
      cidr_blocks = ["0.0.0.0/0"]
    }

    ssh = {
      description = "SSH"
      port        = 22
      cidr_blocks = ["10.0.0.0/8"]
    }
  }
}

resource "aws_security_group" "app" {
  name        = "terraform-dynamic-learning"
  description = "Learning dynamic blocks"

  dynamic "ingress" {
    for_each = var.ingress_rules
    iterator = rule

    content {
      description = rule.value.description
      from_port   = rule.value.port
      to_port     = rule.value.port
      protocol    = "tcp"
      cidr_blocks = rule.value.cidr_blocks
    }
  }
}