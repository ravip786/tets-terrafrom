module "vpc" {
  source              = "./modules/vpc"
  name                = "Date"
  cidr                = "10.0.0.0/16"
  azs                 = ["us-east-1a", "us-east-1b"]
  public_subnets      = ["10.0.0.0/19", "10.0.32.0/19"]
  ecs_subnets         = ["10.0.64.0/19", "10.0.96.0/19"]
  database_subnet     = ["10.0.128.0/19", "10.0.160.0/19"]
  enable_dns_hostnames = true
  enable_nat_gateway  = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "ecs_cluster" {
  source              = "./modules/ecs_cluster"
  name                = "Date-ecs-cluster"
  container_insights  = true

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_alb_sg" {
  source                = "./modules/security_group"
  create                = true
  name                  = "Date-${var.environment}-example-alb-security-group"
  vpc_id                = module.vpc.vpc_id
  source_cidr_block     = true
  source_cidr_rules     = local.payload_example_alb_cidr_rules
  source_security_group = false
  source_self           = false

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "example_lb" {
  source          = "./modules/aws_alb"
  create_lb       = true
  name            = "Date-${var.environment}-example-alb"
  security_groups = [module.example_alb_sg.security_group_id]
  subnets         = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}