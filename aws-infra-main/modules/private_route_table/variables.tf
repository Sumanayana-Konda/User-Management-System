variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of IDs of private subnets"
}

variable "private_route_table_cidr" {
  type        = string
  description = "CIDR block for private route table"
}


# variable "internet_gateway_id" {
#   type        = string
#   description = "ID of the internet gateway to use as the default route target"
# }