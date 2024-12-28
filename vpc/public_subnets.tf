resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id = aws_vpc.main.id

  cidr_block        = var.public_subnets[count.index].cidr
  availability_zone = var.public_subnets[count.index].availability_zone

  tags = merge(
    {
      Name = format("%s-%s", var.project_name, var.public_subnets[count.index].name)
    },
    var.common_tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = format("%s-igw", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-route-public-%s", var.project_name, var.public_subnets[count.index].availability_zone)
  }
}

resource "aws_route" "public" {
  count = length(var.public_subnets)

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = aws_route_table.public[count.index].id
  gateway_id     = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}
