resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.main.id

  cidr_block        = var.private_subnets[count.index].cidr
  availability_zone = var.private_subnets[count.index].availability_zone

  tags = merge(
    {
      Name = format("%s-%s", var.project_name, var.private_subnets[count.index].name)
    },
    var.common_tags
  )
}

resource "aws_eip" "eip" {
  count  = var.unique_natgw == true ? 1 : length(var.public_subnets)
  domain = "vpc"

  tags = merge(
    {
      Name = var.unique_natgw == true ? format("%s-eip", var.project_name) : format("%s-eip-%s", var.project_name, var.public_subnets[count.index].availability_zone)
    },
    var.common_tags
  )
}

resource "aws_nat_gateway" "private" {
  count = var.unique_natgw == true ? 1 : length(var.public_subnets)

  allocation_id = var.unique_natgw == true ? aws_eip.eip[0].id : aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      Name = var.unique_natgw == true ? format("%s-natgw", var.project_name) : format("%s-natgw-%s", var.project_name, var.public_subnets[count.index].availability_zone)
    },
    var.common_tags
  )
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-route-private-%s", var.project_name, var.private_subnets[count.index].availability_zone)
  }
}

resource "aws_route" "private" {
  count = length(var.private_subnets)

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = aws_route_table.private[count.index].id
  nat_gateway_id = var.unique_natgw == true ? aws_nat_gateway.private[0].id : aws_nat_gateway.private[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
