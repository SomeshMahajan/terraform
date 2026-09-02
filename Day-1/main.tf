data = "aws_vpc" "default" {
    default = true
}

resource "aws_security_group" "sg" {
    name = "my_security_group"
    description = "my_security_group"
    vpc_id = data.aws_vpc.default.id

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
        Name = "my_security"
    }
}

resource "aws_instance" "ec2" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group_id]

    user_data = file("/root/terraform/Day-1/user.sh")

    root_block_device {
        volume_size = 10
        volume_type = "gp3"
    }

    tags = {
        Name = "ec2"
    }
}