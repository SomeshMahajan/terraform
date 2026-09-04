output "alb_dns" {
    value = aws_lb.lb.dns_name
}

output "sg_id" {
    value = aws_security_group.sg.id 
}