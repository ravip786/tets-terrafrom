locals {
  payload_example_ecs_cidr_rules = [
    {
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allows IPv4 HTTP inbound taffic"
    },
    {
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv4 all outbound traffic"
    },
    {
      type        = "egress"
      ipv6_cidr_blocks = ["::/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv6 all outbound traffic"
    },
    {
      type        = "ingress"
      cidr_blocks = [module.vpc.vpc_cidr_block]
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "Allow IPv4 all inbound traffic"
    }
  ]

  payload_example_alb_cidr_rules = [
    {
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allows IPv4 HTTP inbound taffic"
    },
    {
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv4 all outbound traffic"
    },
    {
      type        = "egress"
      ipv6_cidr_blocks = ["::/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv6 all outbound traffic"
    },
    {
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allows IPv4 HTTPS inbound taffic"
    },
    {
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Allows IPv4 HTTPS inbound taffic"
    }
      
  ]

  payload_example_rds_cidr_rules = [
    {
      type        = "ingress"
      cidr_blocks = [module.vpc.vpc_cidr_block]
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allows IPv4 MySQL inbound taffic to VPC CIDR"
    },
    {
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv4 all outbound traffic"
    },
    {
      type        = "egress"
      ipv6_cidr_blocks = ["::/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv6 all outbound traffic"
    }
  ]
    payload_example_ecs_cidr_rules = [
    {
      type        = "ingress"
      cidr_blocks = [module.vpc.vpc_cidr_block]
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Allows IPv4 MySQL inbound taffic to VPC CIDR"
    },
    {
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv4 all outbound traffic"
    },
    {
      type        = "egress"
      ipv6_cidr_blocks = ["::/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv6 all outbound traffic"
    }
  ]
  payload_efs_cidr_rules = [
    {
      type        = "ingress"
      cidr_blocks = [module.vpc.vpc_cidr_block]
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "Allow IPv4 all inbound traffic"
    },
    {
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv4 all outbound traffic"
    },
    {
      type        = "egress"
      ipv6_cidr_blocks = ["::/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow IPv6 all outbound traffic"
    }
  ]

  payload_efs = [
    {
      name = "Date-${var.environment}-example-efs"
      performance_mode = "generalPurpose"
      throughput_mode = "bursting"
      transition_to_ia  = "AFTER_30_DAYS"
      subnets = [
        {
          id =  module.vpc.ecs_subnets[0]
        },
        {
          id =  module.vpc.ecs_subnets[1]
        }
      ]
    }
  ]
}