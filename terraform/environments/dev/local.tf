locals {
  ecs_cluster_name = "ap-${var.environment}-ecs-cluster"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "PlatformTeam"
    ManagedBy   = "Terraform"
  }
}
