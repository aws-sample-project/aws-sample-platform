locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "PlatformTeam"
    ManagedBy   = "Terraform"
  }

  principal_arns = data.aws_caller_identity.current.arn
}
