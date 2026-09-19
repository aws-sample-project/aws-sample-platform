resource "aws_ecr_repository" "ecr" {
  for_each             = toset(["cart", "ui", "catalog"])
  name                 = "${var.project_name}-${var.environment}-${each.key}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}