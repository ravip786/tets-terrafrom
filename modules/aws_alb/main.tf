resource "aws_lb" "this" {
  count       = var.create_lb ? 1 : 0
  name        = var.name
  name_prefix = var.name_prefix

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.security_groups
  subnets            = var.subnets

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = try(access_logs.value.enabled, try(access_logs.value.bucket, null) != null)
      bucket  = try(access_logs.value.bucket, null)
      prefix  = try(access_logs.value.prefix, null)
    }
  }

  tags = merge(
    var.tags,
    var.lb_tags,
    {
      Name = var.name != null ? var.name : var.name_prefix
    },
  )

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}

resource "aws_lb_listener" "http" {
  count             = var.create_lb && var.create_https_redirect ? 1 : 0
  load_balancer_arn = aws_lb.this[0].id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type            = "redirect"

      redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    
  }
}

resource "aws_lb_listener" "https" {
  count             = var.create_lb && var.create_default_404 ? 1 : 0
  load_balancer_arn = aws_lb.this[0].id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:us-east-1:033333781728:certificate/b31e7cea-01cb-4dce-afba-c83dd6e527ee"

  default_action {
    type            = "fixed-response"

    fixed_response {
      status_code   = "404"
      content_type  = "text/plain"
    }
  }
}
resource "aws_lb_listener_certificate" "example" {
  listener_arn     = aws_lb_listener.https[0].arn
  certificate_arn  = "arn:aws:acm:us-east-1:033333781728:certificate/881ef7d2-3bbd-4c2e-a678-f1bafc878b76"
 
}