# resource "aws_db_parameter_group" "rds_parameter" {
#   name   = "rds-pg"
#   family = "mysql5.6"

#   parameter {
#     name  = "character_set_server"
#     value = "utf8"
#   }

#   parameter {
#     name  = "character_set_client"
#     value = "utf8"
#   }
# }