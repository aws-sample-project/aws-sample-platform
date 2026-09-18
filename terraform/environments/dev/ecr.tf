resource "aws_ecr_repository" "ecr" {
  name                 = "${var.project_name}-${var.environment}-ecr"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}