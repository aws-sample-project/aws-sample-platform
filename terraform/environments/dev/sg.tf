resource "aws_security_group" "alb" {
  name   = "${var.project_name}-${var.environment}-alb-sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "ui" {
  name   = "${var.project_name}-${var.environment}-ui-sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${var.environment}-ui-sg"
  }
}

resource "aws_security_group" "catalog" {
  name   = "${var.project_name}-${var.environment}-catalog-sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${var.environment}-catalog-sg"
  }
}

resource "aws_security_group" "cart" {
  name   = "${var.project_name}-${var.environment}-cart-sg"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${var.environment}-cart-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  description       = "Allow HTTP traffic from the internet"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ui" {
  description                  = "Allow outbound traffic to UI service"
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.ui.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ui_from_alb" {
  description                  = "Allow traffic from the ALB"
  security_group_id            = aws_security_group.ui.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ui_https" {
  description       = "Allow HTTPS outbound for ECR and AWS APIs"
  security_group_id = aws_security_group.ui.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "catalog_from_ui" {
  description                  = "Allow traffic from the UI"
  security_group_id            = aws_security_group.catalog.id
  referenced_security_group_id = aws_security_group.ui.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "cart_from_ui" {
  description                  = "Allow traffic from the UI"
  security_group_id            = aws_security_group.cart.id
  referenced_security_group_id = aws_security_group.ui.id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
}
