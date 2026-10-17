# Create application load balancer
resource "aws_lb" "alb" {
  count = var.enable_alb ? 1 : 0

  name               = "${var.project_name}-${var.environment}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [
    var.public_subnet_a_id,
    var.public_subnet_b_id
  ]
}

# Create target group for the UI service
resource "aws_lb_target_group" "ui" {
  count = var.enable_alb ? 1 : 0

  name        = "${var.project_name}-${var.environment}-ui-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/actuator/health"
    port                = "traffic-port"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "retail-store-ui-tg"
    Environment = var.environment
    Service     = "ui"
  }
}

# Create listener for the ALB to forward traffic to the UI target group
resource "aws_lb_listener" "http" {
  count = var.enable_alb ? 1 : 0

  load_balancer_arn = aws_lb.alb[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ui[count.index].arn
  }
}