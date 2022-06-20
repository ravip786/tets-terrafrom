data "aws_ssm_parameter" "example_rds_master_user_name" {
  name = "/${var.application}/${var.environment}/rds/master-username"
}

data "aws_ssm_parameter" "example_rds_master_user_password" {
  name = "/${var.application}/${var.environment}/rds/master-password"
}

data "aws_ssm_parameter" "example_rds_master_dbname" {
  name = "/${var.application}/${var.environment}/rds/master-dbname"
}

data "aws_ssm_parameter" "example_rds_master_dbport" {
  name = "/${var.application}/${var.environment}/rds/master-dbport"
}
resource "aws_db_subnet_group" "this" {
  count = var.create ? 1 : 0

  name        = "${var.name}-subnet-group"
  description = var.description
  subnet_ids  = var.subnet_ids

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}-subnet-group"
    },
  )
}


resource "aws_db_instance" "this" {
  count = var.create ? 1 : 0

  identifier = var.name

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  username                            = data.aws_ssm_parameter.example_rds_master_user_name.value
  password                            = data.aws_ssm_parameter.example_rds_master_user_password.value
  db_name                             = data.aws_ssm_parameter.example_rds_master_dbname.value
  port                                = data.aws_ssm_parameter.example_rds_master_dbport.value

  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  vpc_security_group_ids              = var.vpc_security_group_ids
  db_subnet_group_name                = aws_db_subnet_group.this[0].id

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  skip_final_snapshot         = var.skip_final_snapshot


  replicate_source_db     = var.replicate_source_db
  replica_mode            = var.replica_mode
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  max_allocated_storage   = var.max_allocated_storage
  monitoring_interval     = var.monitoring_interval

  character_set_name              = var.character_set_name
  timezone                        = var.timezone

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  tags = var.tags

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

  lifecycle {
    ignore_changes = [
      latest_restorable_time
    ]
  }
}

  
  