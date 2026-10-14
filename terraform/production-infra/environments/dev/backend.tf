terraform {
  backend "s3" {
    bucket       = "h4num4nth4-terraform-state"
    key          = "production-infra/dev/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}