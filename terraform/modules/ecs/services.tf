# Define ECS service
resource "aws_ecs_service" "ui_service" {
  name            = "ui_service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  dynamic "load_balancer" {
    for_each = var.enable_alb ? [1] : []

    content {
      target_group_arn = var.ui_target_group_arn
      container_name   = "ui"
      container_port   = 8080
    }
  }

  network_configuration {
    subnets          = [var.public_subnet_a_id, var.public_subnet_b_id]
    security_groups  = [var.ui_security_group_id]
    assign_public_ip = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution_policy
  ]
}