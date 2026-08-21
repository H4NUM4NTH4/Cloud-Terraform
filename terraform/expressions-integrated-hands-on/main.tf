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
  type = map(object({
    instance_type = string
    monitoring    = bool
    tags          = map(string)
  }))

  default = {
    dev = {
      instance_type = "t3.micro"
      monitoring    = false

      tags = {
        Team = "Development"
      }
    }

    qa = {
      instance_type = "t3.micro"
      monitoring    = false

      tags = {
        Team = "QA"
      }
    }

    prod = {
      instance_type = "t3.large"
      monitoring    = true

      tags = {
        Team = "Production"
      }
    }
  }
}

locals {
  common_tags = {
    Project   = "Terraform-Learning"
    ManagedBy = "Terraform"
  }

  monitored_environments = {
    for name, environment in var.environments :
    name => environment
    if environment.monitoring
  }
}

resource "aws_s3_bucket" "app" {
  for_each = local.monitored_environments

  bucket = "h4num4nth4-integrated-${each.key}-2026"

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Environment  = each.key
      InstanceType = each.value.instance_type
      Monitoring   = tostring(each.value.monitoring)
    }
  )
}


resource "aws_s3_bucket_lifecycle_configuration" "app" {
  for_each = local.monitored_environments
  bucket   = aws_s3_bucket.app[each.key].id

  dynamic "rule" {
    for_each = {
      logs = {
        prefix = "logs/"
      }
    }

    content {
      id     = rule.key
      status = "Enabled"

      filter {
        prefix = rule.value.prefix
      }
    }
  }
}

