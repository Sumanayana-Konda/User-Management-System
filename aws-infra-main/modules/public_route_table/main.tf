
resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.public_route_table_cidr
    gateway_id = var.internet_gateway_id
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_route_table" {
  for_each = { for idx, subnet_id in var.public_subnet_ids : idx => subnet_id }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_route_table.id
}
