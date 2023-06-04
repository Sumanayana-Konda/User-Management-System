# # security group
resource "aws_security_group" "database" {
  name        = "database"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Postgre traffic from only application"
    from_port       = "5432"
    to_port         = "5432"
    protocol        = "tcp"
    security_groups = [var.application_security_group_id]
  }
}

# # #db subnet group
resource "aws_db_subnet_group" "database" {
  name        = "database"
  description = "DB subnet group for database"
  subnet_ids  = var.private_subnet_ids
}

# Create a new RDS parameter group for PostgreSQL 13.3
resource "aws_db_parameter_group" "database" {
  name        = "csye622"
  family      = "postgres13"
  description = "My PostgreSQL 13.3 parameter group"
}


# postgre rds instance
resource "aws_db_instance" "database" {
  # count                  = var.db_instance_count
  allocated_storage      = var.settings.database.allocated_storage
  engine                 = var.settings.database.engine
  engine_version         = "13.3"
  instance_class         = var.settings.database.instance_class
  db_name                = var.settings.database.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]
  multi_az               = false
  identifier             = var.settings.database.identifier
  publicly_accessible    = false
  skip_final_snapshot    = true
  parameter_group_name   = aws_db_parameter_group.database.name
  storage_encrypted = true
  kms_key_id = aws_kms_key.database_key.arn
}
resource "aws_kms_key" "database_key" {
  description = "KMS key for encrypting the RDS instance"
}