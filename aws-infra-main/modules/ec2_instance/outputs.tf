output "private_key_file" {
  value = local_file.private_key.filename
}
output "application_security_group_id" {
  value = aws_security_group.application.id
}

# output "instance_id"{
#   value = aws_instance.Webapp_ec2[0].id
# }
