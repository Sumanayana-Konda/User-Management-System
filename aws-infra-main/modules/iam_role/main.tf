resource "aws_iam_role" "EC2_CSYE6225" {
  name = "EC2-CSYE6225"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "EC2-CSYE6225"
  }
}

resource "aws_iam_role_policy_attachment" "webapp_s3_attachment" {
  policy_arn = var.WebAppS3_policy_arn
  role       = aws_iam_role.EC2_CSYE6225.name
}
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.EC2_CSYE6225.name
}
