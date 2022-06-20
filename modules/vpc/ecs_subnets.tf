################################################################################
# ECS subnets & Routes
################################################################################
resource "aws_subnet" "ecs" {
  count = var.create_vpc && length(var.ecs_subnets) > 0 && length(var.ecs_subnets) >= length(var.azs) ? length(var.ecs_subnets) : 0

  vpc_id                          = aws_vpc.this[0].id
  cidr_block                      = element(concat(var.ecs_subnets, [""]), count.index)
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch         = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.ecs_subnet_suffix}-subnet-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.ecs_subnet_tags,
  )
}

resource "aws_route_table" "ecs" {
  count = var.create_vpc && length(var.ecs_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    { "Name" = "${var.name}-${var.ecs_subnet_suffix}" },
    var.tags,
    var.ecs_route_table_tags,
  )
}

resource "aws_route_table_association" "ecs" {
  count = var.create_vpc && length(var.ecs_subnets) > 0 ? length(var.ecs_subnets) : 0

  subnet_id      = element(aws_subnet.ecs[*].id, count.index)
  route_table_id = aws_route_table.ecs[0].id
}

resource "aws_route" "ecs_natgw" {
  count = var.create_vpc && var.enable_nat_gateway && length(var.ecs_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.ecs[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}