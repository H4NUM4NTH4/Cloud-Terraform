variable "name" {
  description = "Name prefix for networking resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Public subnet configuration."
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "tags" {
  description = "Common tags applied to networking resources."
  type        = map(string)
  default     = {}
}


variable "map_public_ip_on_launch" {
  description = "Whether instances launched in public subnets automatically receive public IPv4 addresses."
  type        = bool
  default     = false
}