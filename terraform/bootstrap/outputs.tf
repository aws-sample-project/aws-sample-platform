output "bootstrap_remote_backend" {
  description = "Remote backend configuration for Terraform state"
  sensitive   = true
  value = {
    bucket   = aws_s3_bucket.backend.bucket
    region   = data.aws_region.current.region
    role_arn = aws_iam_role.iam_role.arn
  }
}