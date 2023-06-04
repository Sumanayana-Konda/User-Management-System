variable "vpc_id" {
  description = "The ID of the VPC to create subnets in"
}

variable "public_subnet_cidrs" {
  description = "The IP ranges for the public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to create subnets in"
  type        = list(string)
}
