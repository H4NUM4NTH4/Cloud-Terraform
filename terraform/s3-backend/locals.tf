locals {
  project_name = "terraform-learning"

  common_tags = {
    Project     = local.project_name
    ManagedBy   = "Terraform"
    Owner       = "Hanumantha"
    Environment = "Learning"
  }
}