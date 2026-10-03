
# Define the CloudWatch log group for the application
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${var.project_name}/${var.environment}/app"
  retention_in_days = 7

  tags = var.tags
}

# Define the ECS task definition for the application
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-${var.environment}-task-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "ui"
      image     = "${var.ui_repository_url}:${var.container_image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ui"
        }
      }
    }
  ])

  tags = var.tags
}
