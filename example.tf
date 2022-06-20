module "example_acm" {
  source            = "./modules/acm"
  domain_name       = "example.Date.co"
  validation_method = "DNS"

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_ecr" {
  source              = "./modules/ecr"
  name                = "Date-example"

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
  port            = "8080"
  vpc_id          = module.vpc.vpc_id

  target_group_rule = [
    {
      listener_arn  = module.example_lb.lb_listener_arn
      priority      = "2"
      host_header   = "example.Date.co"
    }
  ]

  health_check      = {
    matcher = "200-403"
  
  }
 
  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

data "template_file" "example" {
  template = file("task-definitions/example.json")

  vars = {
    image_url         = "033333781728.dkr.ecr.us-east-1.amazonaws.com/Date-example"
    container_name    = "Date-example"
  }
}

module "example_sg" {
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

module "example_service" {
  source                = "./modules/example_ecs_services"
  name                  = "Date-${var.environment}-example"
  cluster_id            = module.ecs_cluster.cluster_id
  desired_count         = 1
  container_definitions = data.template_file.example.rendered
  container_name        = "Date-example"
  container_port        = "8080"

  // Network Configuration
  subnet_ids          = module.vpc.ecs_subnets
  security_group_ids  = [module.example_sg.security_group_id]

  // Loadbalancer configuration
  target_group_arn  = module.example_tg.target_group_arn

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_efs_sg" {
  source                = "./modules/security_group"
  create                = true
  name                  = "Date-${var.environment}-example-efs-security-group"
  vpc_id                = module.vpc.vpc_id
  source_cidr_block     = true
  source_cidr_rules     = local.payload_efs_cidr_rules
  source_security_group = false
  source_self           = false

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_efs" {
  source               = "./modules/efs"
  payload_efs          = local.payload_efs
  security_group_ids   = [module.example_efs_sg.security_group_id]

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
