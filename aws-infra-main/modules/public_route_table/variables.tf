variable "vpc_id" {
  description = "The ID of the VPC to create the public route table in"
  type        = string
}

variable "internet_gateway_id" {
  description = "The ID of the Internet Gateway to use as the target for the default route"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of IDs for public subnets to associate with the public route table"
  type        = list(string)
}

variable "public_route_table_cidr" {
  type        = string
  description = "The CIDR block of the public route table"
}