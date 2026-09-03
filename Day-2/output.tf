output "public_ip" {
    value = aws_instance.public_instance.public_ip
}

output "elastic_ip" {
    value = aws_eip.nat_eip.public_ip
}

output "sg_id" {
    value = aws_security_group.sg.id 
}