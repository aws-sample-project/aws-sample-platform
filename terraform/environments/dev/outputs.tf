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