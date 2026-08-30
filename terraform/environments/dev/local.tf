locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "PlatformTeam"
    ManagedBy   = "Terraform"
  }
}
