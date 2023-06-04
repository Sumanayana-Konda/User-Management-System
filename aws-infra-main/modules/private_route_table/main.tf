resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table_association" "private_route_table" {
  for_each = { for idx, subnet_id in var.private_subnet_ids : idx => subnet_id }
  subnet_id      = each.value
  route_table_id = aws_route_table.private_route_table.id  
}
