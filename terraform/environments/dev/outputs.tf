output "vpc_id" {
  description = "ID of the dev VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_a_id" {
  description = "ID of the public subnet in the first available Availability Zone"
  value       = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  description = "ID of the public subnet in the second available Availability Zone"
  value       = aws_subnet.public_b.id
}

output "public_subnet_ids" {
  description = "IDs of the dev public subnets"
  value = {
    public_a = aws_subnet.public_a.id
    public_b = aws_subnet.public_b.id
  }
}

output "internet_gateway_id" {
  description = "ID of the VPC internet gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the route table associated with the public subnets"
  value       = aws_route_table.public.id
}

output "ecr_repository_url" {
  description = "URLs of the ECR repositories"
  value = {
    for service, repository in aws_ecr_repository.ecr : service => repository.repository_url
  }
}

output "ecs_task_definition_arn" {
  description = "ARN of the dev ECS application task definition"
  value       = aws_ecs_task_definition.app.arn
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_log_group_name" {
  description = "CloudWatch log group used by the ECS application task"
  value       = aws_cloudwatch_log_group.app.name
}
