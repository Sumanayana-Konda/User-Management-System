resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = var.vpc_id
  cidr_block = var.public_subnet_cidrs[count.index]
  # availability_zone = var.availability_zones[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Public Subnet"
  }
}

