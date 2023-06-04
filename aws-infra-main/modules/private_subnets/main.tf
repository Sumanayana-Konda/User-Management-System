resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Private Subnet"
  }
}

