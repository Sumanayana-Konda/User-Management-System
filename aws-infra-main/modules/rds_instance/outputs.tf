output "database_security_group_id" {
  value = aws_security_group.database.id
}

output "database_endpoint" {
  value = aws_db_instance.database.endpoint
}

output "database_username" {
  value = aws_db_instance.database.username
}

output "database_password" {
  value = aws_db_instance.database.password
}
