resource "aws_lb" "application" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  
  security_groups = [aws_security_group.load_balancer.id]

  dynamic "subnet_mapping" {
    for_each = var.public_subnet_ids
    content {
      subnet_id = subnet_mapping.value
    }
  }
  tags = {
    Name = "example-alb"
  }
}

resource "aws_security_group" "load_balancer" {
  name_prefix = "load-balancer-sg-"
  description = "Security group for the load balancer"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load_balancer"
  }
}



resource "aws_lb_listener" "Webapp_lb_listener" {
  load_balancer_arn = aws_lb.application.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Webapp-tg.arn
  }
}


resource "aws_lb_target_group" "Webapp-tg" {
  name        = "Webapp-tg"
 port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 90
    timeout             = 60
    path                = "/healthz"
    port                = "3000"
    protocol            = "HTTP"
  }

  tags = {
    Name = "Webapp-tg"
  }

}
