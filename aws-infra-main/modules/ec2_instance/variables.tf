variable "ami_id" {
  description = "ID of the AMI to use for the EC2 instance"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
}

variable "ssh_key_name" {
  description = "Name of SSH key pair to use for EC2 instance login"
  default = "my_key"
}

variable "root_volume_size" {
  description = "Size of root volume for the EC2 instance"
}

variable "protect_from_termination" {
  description = "Whether to protect the EC2 instance from accidental termination"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "ec2_instance_count" {
  description = "Instance type for the EC2 instance"
  default = 1
}

variable "application_port" {
  type    = number
  default = 3000
}

variable "public_subnet_ids" {
}

variable "keyname" {
  default = "key"

}

variable "iam_role_name" {
  
}
variable "s3_bucket_name" {
  
}

variable "database_endpoint" {
  
}

variable "database_username" {
  
}

variable "database_password" {
  
}

variable "region"{
  default = "us-east-2"
}

variable "zone_id"{
  default = "Z059366130TUKLB8AHN6Y"
}

variable "load_balancer_security_group_id"{
  
}

variable "load_balancer_dns_name"{
  
}

variable "load_balancer_zone_id"{
  
}

variable "load_balancer_target_group_arn"{
  
}