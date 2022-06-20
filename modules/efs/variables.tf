variable "payload_efs" {}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with EFS"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for EFS Tags only."
  type        = map(string)
  default     = {}
}