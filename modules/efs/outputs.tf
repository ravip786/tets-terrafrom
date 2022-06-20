output "efs_id" {
  description = "The id of the EFS filesystem."
  value = {
    for efs in aws_efs_file_system.this :
    efs.tags.Name => efs.id
  }
}

output "efs_arn" {
  description = "The ARN of the EFS filesystem."
  value = {
    for efs in aws_efs_file_system.this :
    efs.tags.Name => efs.arn
  }
}

output "access_point_id" {
  description = "The ARN of the EFS filesystem."
  value = {
    for access_point in aws_efs_access_point.this :
    access_point.tags.Name => access_point.id
  }
}