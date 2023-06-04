resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "key.pem"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = var.keyname
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_security_group" "application" {
  name        = "application"
  description = "application security group"
  vpc_id     = var.vpc_id

ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [var.load_balancer_security_group_id]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
   security_groups = [var.load_balancer_security_group_id]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    description      = "application port"
    from_port        = var.application_port
    to_port          = var.application_port
    protocol         = "tcp"
    security_groups      = [var.load_balancer_security_group_id]
  }
  ingress {
    description      = "Psql"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups      = [var.load_balancer_security_group_id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application"
  }
}

resource "aws_iam_instance_profile" "Webapp_ec2" {
  name = "Webapp_ec2"
  role = var.iam_role_name
}

resource "aws_route53_record" "Webapp_ec2" {
  zone_id = var.zone_id
  name    = ""
  type    = "A"
 alias {
    name                   = var.load_balancer_dns_name
    zone_id                = var.load_balancer_zone_id
    evaluate_target_health = false
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "my-webapp-err-group" {
  name = "my-webapp-err-group"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "my-webapp-info-group" {
  name = "my-webapp-info-group"
  retention_in_days = 7
}

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self","049089338565"]
}

resource "aws_launch_template" "Webapp_ec2" {
  name               = "asg_launch_config"
  image_id           = data.aws_ami.latest.id
  instance_type      = "t2.micro"
  key_name           = aws_key_pair.ec2_key.key_name
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.application.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.Webapp_ec2.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 50
      volume_type = "gp2"
      encrypted   = true
    }
  }

  user_data = base64encode(<<EOF
          #cloud-boothook
          #!/bin/bash
          su - ec2-user -c 'touch /home/ec2-user/.env'
          # Add the values
          su - ec2-user -c 'echo "DB_USER=${var.database_username}" >> /home/ec2-user/.env'
          su - ec2-user -c 'echo "DB_PASSWORD=${var.database_password}" >> /home/ec2-user/.env'
          su - ec2-user -c 'echo "DB_HOST=${element(split(":", var.database_endpoint), 0)}" >> /home/ec2-user/.env'
          su - ec2-user -c 'echo "AWS_BUCKET_NAME=${var.s3_bucket_name}" >> /home/ec2-user/.env'
          su - ec2-user -c 'echo "DB_DB=csye6225" >> /home/ec2-user/.env'
          su - ec2-user -c 'echo "AWS_REGION=${var.region}" >> /home/ec2-user/.env'

          su - ec2-user -c 'pm2 startup'
          su - ec2-user -c 'sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.19.1/bin /home/ec2-user/.nvm/versions/node/v16.19.1/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user'
          su - ec2-user -c 'pm2 start server.js --env=.env'
          su - ec2-user -c 'pm2 save'
          sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/home/ec2-user/config.json -s

          EOF
        )
}

resource "aws_autoscaling_group" "Webapp_ec2" {
  name = "asg_launch_config"
  # launch_configuration = aws_launch_configuration.Webapp_ec2.id
  launch_template {
    id      = aws_launch_template.Webapp_ec2.id
    version = "$Latest"
  }
  depends_on = [
    aws_cloudwatch_log_group.my-webapp-err-group,
    aws_cloudwatch_log_group.my-webapp-info-group,
  ]
  min_size = 1
  max_size = 3
  desired_capacity = 1
  default_cooldown = 60
  vpc_zone_identifier = var.public_subnet_ids
  health_check_type = "EC2"
  tag {
    key                 = "webapp"
    value               = "webappInstance"
    propagate_at_launch = true
  }
}

# resource "aws_autoscaling_policy" "scale_up_policy" {
#   name                   = "scale_up_policy"
#   policy_type            = "SimpleScaling"
#   scaling_adjustment     = "1"
#   cooldown               = "60"
#   adjustment_type = "ChangeInCapacity"
#   autoscaling_group_name = aws_autoscaling_group.Webapp_ec2.name
# }

# resource "aws_autoscaling_policy" "scale_down_policy" {
#    name                   = "scale_down_policy"
#   policy_type            = "SimpleScaling"
#   scaling_adjustment     = "-1"
#   cooldown               = "60"
#   adjustment_type = "ChangeInCapacity"
#   autoscaling_group_name = aws_autoscaling_group.Webapp_ec2.name
# }


# resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
#   alarm_name          = "scale-up-alarm"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = 5
#   alarm_description   = "This metric monitors CPU utilization"
#   alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn]
# }

# resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
#   alarm_name          = "scale-down-alarm"
#   comparison_operator = "LessThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = 3
#   alarm_description   = "This metric monitors CPU utilization"
#   alarm_actions       = [aws_autoscaling_policy.scale_down_policy.arn]
# }

# resource "aws_autoscaling_attachment" "Webapp_ec2" {
#   autoscaling_group_name = aws_autoscaling_group.Webapp_ec2.name
#   lb_target_group_arn   = var.load_balancer_target_group_arn
# }



resource "aws_cloudwatch_metric_alarm" "scaleUpAlarm" {
  alarm_name          = "ASG_Scale_Up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 5

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Webapp_ec2.name
  }

  alarm_description = "Scale up if CPU > 5% for 1 minute"
  alarm_actions     = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "scaleDownAlarm" {
  alarm_name          = "ASG_Scale_Down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 3

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Webapp_ec2.name
  }

  alarm_description = "Scale down if CPU < 3% for 2 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_down_policy.arn]
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name = "scale_up_policy"
  policy_type = "SimpleScaling"
  scaling_adjustment = 1
  adjustment_type  = "ChangeInCapacity" 
  cooldown = 60 # cooldown in seconds
  autoscaling_group_name = aws_autoscaling_group.Webapp_ec2.name
  metric_aggregation_type = "Average"
  # alarm_name = aws_cloudwatch_metric_alarm.cpu_utilization_alarm.name
}


resource "aws_autoscaling_policy" "scale_down_policy" {
  name = "scale_down_policy"
  policy_type = "SimpleScaling"
  scaling_adjustment = -1 
  adjustment_type = "ChangeInCapacity"
  cooldown = 60 # cooldown in seconds
  autoscaling_group_name = aws_autoscaling_group.Webapp_ec2.name
  metric_aggregation_type = "Average"
  # alarm_name = aws_cloudwatch_metric_alarm.cpu_utilization_alarm.name
}

resource "aws_autoscaling_attachment" "Webapp_ec2" {
  autoscaling_group_name = aws_autoscaling_group.Webapp_ec2.name
  lb_target_group_arn    = var.load_balancer_target_group_arn
}