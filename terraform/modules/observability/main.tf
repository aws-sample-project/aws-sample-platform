# Define the CloudWatch log group for the application
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${var.project_name}/${var.environment}/app"
  retention_in_days = 1
}