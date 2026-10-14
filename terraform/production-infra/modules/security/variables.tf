variable "name" {
  description = "Name prefix for security resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created."
  type        = string
}

variable "tags" {
  description = "Common tags for security resources."
  type        = map(string)
  default     = {}
}