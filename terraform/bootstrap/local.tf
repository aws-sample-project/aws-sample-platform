locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "PlatformTeam"
    ManagedBy   = "Terraform"
  }

  account_id = data.aws_caller_identity.current.account_id
}
