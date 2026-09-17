output "public_ip" {
  description = "Public IP addresses of the public EC2 instances"
  value       = aws_instance.public_instance[*].public_ip
}

output "elastic_ip" {
  description = "Elastic IP address assigned to the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}

output "private_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = aws_instance.private_instance.private_ip
}

output "sg_id" {
  description = "Security Group ID"
  value       = aws_security_group.sg.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    aws_subnet.easycrud_public_1.id,
    aws_subnet.easycrud_public_2.id
  ]
}

output "private_app_subnet_ids" {
  description = "IDs of the private application subnets"
  value = [
    aws_subnet.easycrud_private_app_1.id,
    aws_subnet.easycrud_private_app_2.id
  ]
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets"
  value = [
    aws_subnet.easycrud_private_db_1.id,
    aws_subnet.easycrud_private_db_2.id
  ]
}