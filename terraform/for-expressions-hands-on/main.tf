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

    prod = {
      instance_type = "t3.large"
      environment   = "prod"
      monitoring    = true
    }
  }
}


output "all_names" {
  value = [
    for name, server in var.servers : name
  ]
}

output "production_servers" {
  value = {
    for name, server in var.servers :
    name => server
    if server.environment == "prod"
  }
}

output "monitored_servers" {
  value = {
    for name, server in var.servers :
    name => server
    if server.monitoring
  }
}

output "instance_types" {
  value = {
    for name, server in var.servers :
    name => server.instance_type
  }
}

resource "aws_s3_bucket" "monitored" {
  for_each = {
    for name, server in var.servers :
    name => server
    if server.monitoring
  }

  bucket = "h4num4nth4-monitored-${each.key}-2026"

  tags = {
    Environment  = each.value.environment
    InstanceType = each.value.instance_type
    Monitoring   = tostring(each.value.monitoring)
  }
}

# merge() — combining maps and objects
output "merged_tags" {
  value = merge(
    {
      Project   = "terraform-learning"
      ManagedBy = "Terraform"
    },
    {
      Environment = "Learning"
      Owner       = "Hanumantha"
    },
    {
      Environment = "Override-Test"
    }
  )
}

# flatten() is used when you have nested lists and need one flat list.
output "flat_environments" {
  value = flatten([
    ["dev", "qa"],
    ["prod"],
    ["staging", "test"]
  ])
}


# lookup() is Used to safely retrieve a value from a map
output "lookup_example" {
  value = lookup(
    {
      dev  = "t3.micro"
      prod = "t3.large"
    },
    "prod",
    "t3.small"
  )
}


# try() is Useful when an expression might fail.
output "try_example" {
  value = try(
    var.servers["prod"].instance_type,
    "t3.micro"
  )
}

# can() is Used to check if an expression can be evaluated without throwing an error.
output "can_example" {
  value = can(var.servers["prod"].instance_type)
}

# coalesce(): Returns the first non-null/non-empty value.
output "coalesce_example" {
  value = coalesce(
    "",
    null,
    "terraform",
    "fallback"
  )
}