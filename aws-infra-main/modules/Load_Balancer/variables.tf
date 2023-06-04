variable "public_subnet_ids" {
  description = "Public Subnet Id"
}


variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "application_port" {
  type    = number
  default = 3000
}

# variable "instance_id"{

# }

variable "zone_id"{
  default = "Z059366130TUKLB8AHN6Y"
}

variable "certificate_arn"{
  default = "arn:aws:acm:us-east-2:615679487028:certificate/91b4de4a-fea8-4aa8-9e61-456b225ff31c"
}

# dev = arn:aws:acm:us-east-2:049089338565:certificate/37b073f6-b777-4f78-9845-64ae4be8a551