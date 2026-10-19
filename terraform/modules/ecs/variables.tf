variable "cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the ECS cluster."
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "container_image_tag" {
  description = "Tag of the container image to deploy"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "ui_repository_url" {
  description = "ECR repository URL for the UI image"
  type        = string
}

variable "ui_security_group_id" {
  description = "Security group ID for the UI service"
  type        = string
}

variable "public_subnet_a_id" {
  description = "ID of the first public subnet"
  type        = string
}

variable "public_subnet_b_id" {
  description = "ID of the second public subnet"
  type        = string
}

variable "enable_alb" {
  description = "Whether to provision the application load balancer"
  type        = bool
}

variable "ui_target_group_arn" {
  description = "ARN of the ALB target group for the UI service"
  type        = string
  nullable    = true
}
