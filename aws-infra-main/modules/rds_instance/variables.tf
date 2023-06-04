variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "private_subnet_ids" {
  description = "List of IDs of private subnets"
}

variable "settings" {
  description = "configuration"
  type        = map(any)
  default = {
    "database" = {
      allocated_storage = 10
      engine            = "postgres"
      instance_class    = "db.t3.micro"
      db_name           = "csye6225"
      identifier        = "csye6225"
    }
  }
}

variable "db_username" {


}
variable "db_password" {
  

}
variable "application_security_group_id" {
}
variable "db_instance_count" {
  default = 1
}
