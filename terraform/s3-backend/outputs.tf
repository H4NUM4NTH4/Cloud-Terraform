output "bucket_name" {
  description = "Terraform state bucket"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table" {
  description = "Terraform lock table"
  value       = aws_dynamodb_table.terraform_locks.name
}