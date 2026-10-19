output "alb_dns_name" {
  description = "DNS name of the ALB."
  value       = var.enable_alb ? aws_lb.alb[0].dns_name : null
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = var.enable_alb ? aws_lb.alb[0].arn : null
}

output "ui_target_group_arn" {
  description = "ARN of the UI target group."
  value       = var.enable_alb ? aws_lb_target_group.ui[0].arn : null
}
