module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "public_subnets" {
  source = "./modules/public_subnets"

  vpc_id              = module.vpc.vpc_id
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "private_subnets" {
  source = "./modules/private_subnets"

  vpc_id               = module.vpc.vpc_id
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "internet_gateway" {
  source = "./modules/internet_gateway"

  vpc_id = module.vpc.vpc_id
}

module "public_route_table" {
  source = "./modules/public_route_table"

  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.public_subnets.public_subnet_ids
  public_route_table_cidr = var.public_route_table_cidr
  internet_gateway_id     = module.internet_gateway.internet_gateway_id
}

module "private_route_table" {
  source = "./modules/private_route_table"

  vpc_id                   = module.vpc.vpc_id
  private_subnet_ids       = module.private_subnets.private_subnet_ids
  private_route_table_cidr = var.private_route_table_cidr
  # internet_gateway_id     = module.internet_gateway.internet_gateway_id
}

module "rds_instance" {
  source                        = "./modules/rds_instance"
  vpc_id                        = module.vpc.vpc_id
  db_password                   = var.db_password
  db_username                   = var.db_username
  application_security_group_id = module.ec2_instance.application_security_group_id
  private_subnet_ids = module.private_subnets.private_subnet_ids
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
  environment = var.environment
}


module "iam_role" {
  source = "./modules/iam_role"
  WebAppS3_policy_arn = module.iam_policy.WebAppS3_policy_arn
}

module "iam_policy" {
  source = "./modules/iam_policy"
  s3_bucket_name = module.s3_bucket.s3_bucket_name
}


module "ec2_instance" {
  source             = "./modules/ec2_instance"
  ami_id             = var.ami_id
  instance_type      = "t2.micro"
  ssh_key_name       = var.keyname
  root_volume_size   = 50
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.public_subnets.public_subnet_ids
  ec2_instance_count = var.ec2_instance_count
  iam_role_name = module.iam_role.iam_role_name
  s3_bucket_name = module.s3_bucket.s3_bucket_name
  database_endpoint = module.rds_instance.database_endpoint
  database_username = module.rds_instance.database_username
  database_password = module.rds_instance.database_password
  zone_id            = var.zone_id
  load_balancer_security_group_id = module.load_balancer.load_balancer_security_group_id
  load_balancer_dns_name = module.load_balancer.load_balancer_dns_name
  load_balancer_zone_id = module.load_balancer.load_balancer_zone_id
  load_balancer_target_group_arn = module.load_balancer.load_balancer_target_group_arn
}

module "load_balancer" {
  source = "./modules/Load_Balancer"
  public_subnet_ids = module.public_subnets.public_subnet_ids
  vpc_id             = module.vpc.vpc_id

}
