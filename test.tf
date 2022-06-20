######################################################
################## AssetsMgmt Terraform ##############
######################################################
module "example_ecr" {
  source              = "./modules/ecr"
  name                = "Date-example"

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_rds_sg" {
  source                = "./modules/security_group"
  create                = true
  name                  = "Date-${var.environment}-example-rds-security-group"
  vpc_id                = module.vpc.vpc_id
  source_cidr_block     = true
  source_cidr_rules     = local.payload_example_rds_cidr_rules
  source_security_group = false
  source_self           = false

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_rds_db" {
  source                  = "./modules/rds_db"
  create                  = true
  deletion_protection     = true
  application             = "example"
  environment             = var.environment
  name                    = "Date-${var.environment}-example-rds"
  engine                  = "mysql"
  engine_version          = "8.0.28"
  instance_class          = "db.t3.micro"
  allocated_storage       = "40"
  vpc_security_group_ids  = [module.example_rds_sg.security_group_id]
  subnet_ids              = module.vpc.database_subnets
  

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_ecs_sg" {
  source                = "./modules/security_group"
  create                = true
  name                  = "Date-${var.environment}-example-ecs-security-group"
  vpc_id                = module.vpc.vpc_id
  source_cidr_block     = true
  source_cidr_rules     = local.payload_example_ecs_cidr_rules
  source_security_group = false
  source_self           = false

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_tg" {
  source          = "./modules/alb_tg"
  create          = true
  name            = "Date-${var.environment}-example-alb-tg"
  protocol        = "HTTP"
  port            = "80"
  vpc_id          = module.vpc.vpc_id

  target_group_rule = [
    {
      listener_arn  = module.example_lb.lb_listener_arn
      priority      = "1"
      host_header   = "assetsmgmt.Date.co"
    }
  ]

  health_check      = {
    matcher = "200-302"
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

data "template_file" "example" {
  template = file("task-definitions/example.json")

  vars = {
    image_url         = "033333781728.dkr.ecr.us-east-1.amazonaws.com/Date-example:latest"
    container_name    = "Date-example"
    rds_endpoint      = "Date-prod-example-rds.cmb1tpr2f8e6.us-east-1.rds.amazonaws.com"
  }
}

module "example_service" {
  source                = "./modules/example_ecs_service"
  name                  = "Date-${var.environment}-example"
  cluster_id            = module.ecs_cluster.cluster_id
  desired_count         = 1
  container_definitions = data.template_file.example.rendered

  container_name  = "Date-example"

  // Network Configuration
  subnet_ids          = module.vpc.ecs_subnets
  security_group_ids  = [module.example_ecs_sg.security_group_id]

  // Loadbalancer configuration
  target_group_arn  = module.example_tg.target_group_arn

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_acm" {
  source            = "./modules/acm"
  domain_name       = "assetsmgmt.Date.co"
  validation_method = "DNS"

  subject_alternative_names = [
    "assetsmgmt.Date.co"
  ]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}