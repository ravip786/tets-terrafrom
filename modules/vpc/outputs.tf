output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, "")
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this[0].arn, "")
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, "")
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "ecs_subnets" {
  description = "List of IDs of ECS public subnets"
  value       = aws_subnet.ecs[*].id
}

output "ecs_subnet_arns" {
  description = "List of ARNs of ECS public subnets"
  value       = aws_subnet.ecs[*].arn
}

output "database_subnets" {
  description = "List of IDs of Database public subnets"
  value       = aws_subnet.database[*].id
}

output "database_subnet_arns" {
  description = "List of ARNs of Database public subnets"
  value       = aws_subnet.database[*].arn
}
  output "efs_subnets" {
  description = "List of IDs of Database public subnets"
  value       = aws_subnet.database[*].id
}
  
  output "efs_subnet_arns" {
  description = "List of ARNs of Efs public subnets"
  value       = aws_subnet.database[*].arn
}