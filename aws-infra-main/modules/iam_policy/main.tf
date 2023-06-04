resource "aws_iam_policy" "WebAppS3" {
  name = "WebAppS3"
  path        = "/"
  description = "Allow"

  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
            # "s3:*"
           "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
            "arn:aws:s3:::${var.s3_bucket_name}",
            "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
    ]
  })
}
