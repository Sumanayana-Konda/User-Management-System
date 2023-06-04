output "iam_role_name" {
  value = aws_iam_role.EC2_CSYE6225.name
}

output "iam_role_arn" {
  value = aws_iam_role.EC2_CSYE6225.arn
}

output "iam_policy_attachment_id" {
  value = aws_iam_role_policy_attachment.webapp_s3_attachment.id
}
