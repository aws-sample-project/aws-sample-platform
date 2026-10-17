variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "enable_alb" {
  description = "Whether to provision the application load balancer"
  type        = bool
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnet_a_id" {
  description = "ID of the public subnet A"
  type        = string
}

variable "public_subnet_b_id" {
  description = "ID of the public subnet B"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}