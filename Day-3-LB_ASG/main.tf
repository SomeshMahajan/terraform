data "aws_vpc" "default" {
    default = true
}

#data "aws_subnets" "default" {
#    filter {
#        name = "vpc-id"
#        values = [data.aws_vpc.default.id]
#    }
#}

# Create a SECURITY GROUP

resource "aws_security_group" "sg" {
    name = "my_sg"
    description = "my_sg"
    vpc_id = data.aws_vpc.default.id

    # Ingress Rule for SG 

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "my_sg"
    }
}

# Create A LOAD BALANCER

resource "aws_lb_target_group" "tg" {
    name = "tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 30
        timeout = 5
        unhealthy_threshold = 2
        healthy_threshold = 2
    }
}

resource "aws_lb" "lb" {
    name = "ALB"
    load_balancer_type = var.load_balancer_type
    subnets = ["subnet-08ef5ecd2a7e34620","subnet-06ffcf2a3c57920b8"]
    internal = false
    security_groups = [aws_security_group.sg.id]
}

# Create a LISTENER

resource "aws_lb_listener" "listener" {
    load_balancer_arn = var.load_balancer_arn 
    port = var.lb_listener_port
    protocol = var.lb_listener_protocol
    default_action {
        type = "forward"
        target_group_arn = var.target_group_arn 
    }
}

# Create a AUTOSCALING GROUP 

# Create a launch template for asg

resource "aws_launch_template" "lt" {
    name_prefix = "web-template"
    image_id = var.image_id 
    key_name = var.key_name
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.sg.id]
    user_data = filebase64("/home/ubuntu/terraform/Day-3-LB_ASG/user.sh") 
}

resource "aws_autoscaling_group" "asg" {
    name = "ASG"
    desired_capacity = var.desired_capacity
    min_size = var.min_size
    max_size = var.max_size 
    target_group_arns = [aws_lb_target_group.tg.arn] 
    vpc_zone_identifier = ["subnet-08ef5ecd2a7e34620","subnet-06ffcf2a3c57920b8"]
    launch_template {
        id = aws_launch_template.lt.id
        version = "$Latest"
    }
    health_check_type = "ELB"
}