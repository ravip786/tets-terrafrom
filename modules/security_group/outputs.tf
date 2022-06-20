output "security_group_id" {
  description = "The ID of the security group"
  value = concat(
    aws_security_group.this.*.id,
    aws_security_group.this_name_prefix.*.id,
    [var.security_group_id],
    [""],
  )[0]
}

output "security_group_vpc_id" {
  description = "The security group VPC ID."
  value = concat(
    aws_security_group.this.*.vpc_id,
    aws_security_group.this_name_prefix.*.vpc_id,
    [""],
  )[0]
}

output "security_group_owner_id" {
  description = "The security group owner ID"
  value = concat(
    aws_security_group.this.*.owner_id,
    aws_security_group.this_name_prefix.*.owner_id,
    [""],
  )[0]
}

output "security_group_name" {
  description = "The name of the security group"
  value = concat(
    aws_security_group.this.*.name,
    aws_security_group.this_name_prefix.*.name,
    [""],
  )[0]
}

output "security_group_description" {
  description = "The description of the security group"
  value = concat(
    aws_security_group.this.*.description,
    aws_security_group.this_name_prefix.*.description,
    [""],
  )[0]
}
