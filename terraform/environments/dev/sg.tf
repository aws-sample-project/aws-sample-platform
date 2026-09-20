resource "aws_security_group" "alb" {
  name   = "${var.project_name}-${var.environment}-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ui" {
  name   = "${var.project_name}-${var.environment}-ui-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow traffic from the ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
}

resource "aws_security_group" "catalog" {
  name   = "${var.project_name}-${var.environment}-catalog-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow traffic from the UI"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.ui.id]
  }
}

resource "aws_security_group" "cart" {
  name   = "${var.project_name}-${var.environment}-cart-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow traffic from the UI"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.ui.id]
  }
}