################################################################################
# Database subnets & Routes
################################################################################
resource "aws_subnet" "database" {
  count = var.create_vpc && length(var.database_subnet) > 0 && length(var.database_subnet) >= length(var.azs) ? length(var.database_subnet) : 0

  vpc_id                          = aws_vpc.this[0].id
  cidr_block                      = element(concat(var.database_subnet, [""]), count.index)
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.database_subnet_suffix}-subnet-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.database_subnet_tags,
  )
}

resource "aws_route_table" "database" {
  count = var.create_vpc && length(var.database_subnet) > 0 ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = merge(
    { "Name" = "${var.name}-${var.database_subnet_suffix}-rt" },
    var.tags,
    var.database_route_table_tags,
  )
}

resource "aws_route_table_association" "database" {
  count = var.create_vpc && length(var.database_subnet) > 0 ? length(var.database_subnet) : 0

  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database[0].id
}

resource "aws_route" "database_natgw" {
  count = var.create_vpc && var.enable_nat_gateway && length(var.database_subnet) > 0 ? 1 : 0

  route_table_id         = aws_route_table.database[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}