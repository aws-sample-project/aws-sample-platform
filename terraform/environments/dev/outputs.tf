output "vpc_id" {
  description = "ID of the dev VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_a_id" {
  description = "ID of the public subnet in the first available Availability Zone"
  value       = aws_subnet.public_a.id
}

output "internet_gateway_id" {
  description = "ID of the VPC internet gateway"
  value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  description = "ID of the route table associated with the public subnet"
  value       = aws_route_table.public.id
}
