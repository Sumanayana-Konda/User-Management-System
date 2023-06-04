variable "region" {
  description = "The region to create the VPC in"
  type        = string
  default     = "us-east-2"
}

variable "profile" {
  description = "The profile is the account where to deploy the infrastructure"
  type        = string
  default = "dev"
}

variable "vpc_cidr" {
  description = "The IP range for the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "The availability zones to create subnets in"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "public_subnet_cidrs" {
  description = "The IP ranges for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The IP ranges for the private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "public_route_table_cidr" {
  type        = string
  description = "The CIDR block of the public route table"
  default     = "0.0.0.0/0"
}

variable "private_route_table_cidr" {
  type        = string
  description = "The CIDR block of the private route table"
  default     = "0.0.0.0/0"
}

variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
}

variable "subnet_id" {
  description = "ID of the subnet where the EC2 instance will be launched"
  type        = string
  default     = "aws_subnet.public_subnet.1.id"
}

variable "ec2_instance_count" {
  type    = number
  default = 1
}

variable "keyname" {
  default = "my-keypair"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "db_username" {

}
variable "db_password" {

}
variable "db_instance_count" {
  default = 1
}


variable "zone_id" {
  default = "Z059366130TUKLB8AHN6Y"
}

variable "certificate_arn"{
  default = "arn:aws:acm:us-east-2:615679487028:certificate/91b4de4a-fea8-4aa8-9e61-456b225ff31c"
}