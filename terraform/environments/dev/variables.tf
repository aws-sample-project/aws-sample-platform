variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "IPv4 CIDR blocks for the dev public subnets"
  type = object({
    public_a = string
    public_b = string
  })
  default = {
    public_a = "10.0.1.0/24"
    public_b = "10.0.2.0/24"
  }

  validation {
    condition     = alltrue([for cidr in values(var.public_subnet_cidrs) : can(cidrnetmask(cidr))])
    error_message = "Each public subnet CIDR must be a valid IPv4 CIDR block."
  }
}
