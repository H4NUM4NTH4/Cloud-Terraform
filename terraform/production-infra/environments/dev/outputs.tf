output "vpc_id" {
  value = module.networking.vpc_id
}

output "app_security_group_id" {
  value = module.security.app_security_group_id
}


output "bucket_name" {
  value = module.storage.bucket_id
}

output "bucket_arn" {
  value = module.storage.bucket_arn
}