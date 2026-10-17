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

variable "egress_rules" {
  description = "Explicit outbound rules required by application workloads."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}