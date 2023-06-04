variable "vpc_cidr" {
  description = "The IP range for the VPC"
}

variable "public_subnet_cidrs" {
  description = "The IP ranges for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The IP ranges for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zones to create subnets in"
  type        = list(string)
}
