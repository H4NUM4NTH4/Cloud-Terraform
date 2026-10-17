variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "tags" {
  description = "Common tags for the S3 bucket."
  type        = map(string)
  default     = {}
}


variable "kms_key_arn" {
  description = "Optional customer-managed KMS key ARN for S3 encryption."
  type        = string
  default     = null
}