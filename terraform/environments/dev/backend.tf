terraform {
  backend "s3" {
    bucket         = "aws-devops-project-s3-backend"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-1"
    use_lockfile   = true
    encrypt        = true
    assume_role = {
      role_arn = "arn:aws:iam::935322848615:role/Aws-Devops-ProjectS3BackendRole"
    }
  }
}