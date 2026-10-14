terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Project     = "production-infra"
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}

module "networking" {
  source = "../../modules/networking"

  name     = "prod-infra-dev"
  vpc_cidr = "10.20.0.0/16"

  public_subnets = {
    public_a = {
      cidr = "10.20.1.0/24"
      az   = "ap-south-1a"
    }

    public_b = {
      cidr = "10.20.2.0/24"
      az   = "ap-south-1b"
    }
  }

  tags = {
    Component = "networking"
  }
}


module "security" {
  source = "../../modules/security"

  name   = "prod-infra-dev"
  vpc_id = module.networking.vpc_id

  tags = {
    Component = "security"
  }
}



module "storage" {
  source = "../../modules/storage"

  bucket_name = "h4num4nth4-production-infra-dev-2026"

  tags = {
    Component = "storage"
  }
}