output "alb_arn" {
  value = aws_lb.application.arn
}

output "load_balancer_security_group_id" {
  value = aws_security_group.load_balancer.id
}

output "load_balancer_dns_name"{
  value = aws_lb.application.dns_name
}

output "load_balancer_zone_id"{
  value = aws_lb.application.zone_id
}

output "load_balancer_target_group_arn"{
  value = aws_lb_target_group.Webapp-tg.arn
}

