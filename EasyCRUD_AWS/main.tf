resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "my_vpc"
    }
}

resource "aws_subnet" "easycrud_public_1" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.public_cidr_1
    availability_zone = var.public_az_1
    map_public_ip_on_launch = true
    tags = {
        Name = "easycrud_public_1"
    }
}
resource "aws_subnet" "easycrud_public_2" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.public_cidr_2
    availability_zone = var.public_az_2
    map_public_ip_on_launch = true
    tags = {
        Name = "easycrud_public_2"
    }
}

resource "aws_subnet" "easycrud_private_app_1" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.private_cidr_1
    availability_zone = var.private_az_1
    tags = {
        Name = "easycrud_private_app_1"
    }
}
resource "aws_subnet" "easycrud_private_app_2" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.private_cidr_2
    availability_zone = var.private_az_2
    tags = {
        Name = "easycrud_private_app_2"
    }
}

resource "aws_subnet" "easycrud_private_db_1" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.private_db_cidr_1
    availability_zone = var.private_db_az_1
    tags = {
        Name = "easycrud_private_db_1"
    }
}

resource "aws_subnet" "easycrud_private_db_2" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = var.private_db_cidr_2
    availability_zone = var.private_db_az_2
    tags = {
        Name = "easycrud_private_db_2"
    }
}


# Internet Gateway
resource "aws_internet_gateway" "easycrud_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "easycrud_igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat_eip"
  }
}

# NAT Gateway
# NAT Gateway must be placed in a public subnet
resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.easycrud_public_1.id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "nat"
  }

  depends_on = [
    aws_internet_gateway.easycrud_igw
  ]
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.easycrud_igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# Public Subnet 1 Association
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.easycrud_public_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Public Subnet 2 Association
resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.easycrud_public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_rt"
  }
}

# Private Application Subnet 1 Association
resource "aws_route_table_association" "private_rt_assoc_app_1" {
  subnet_id      = aws_subnet.easycrud_private_app_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Private Application Subnet 2 Association
resource "aws_route_table_association" "private_rt_assoc_app_2" {
  subnet_id      = aws_subnet.easycrud_private_app_2.id
  route_table_id = aws_route_table.private_rt.id
}

# Private Database Subnet 1 Association
resource "aws_route_table_association" "private_rt_assoc_db_1" {
  subnet_id      = aws_subnet.easycrud_private_db_1.id
  route_table_id = aws_route_table.private_rt.id
}

# Private Database Subnet 2 Association
resource "aws_route_table_association" "private_rt_assoc_db_2" {
  subnet_id      = aws_subnet.easycrud_private_db_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "sg" {
    name = "my_sg"
    description = "my_sg"
    vpc_id = aws_vpc.my_vpc.id 

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
}


# Public EC2 Instances
resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  count = 2

  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  # Distribute instances across public subnets
  subnet_id = element(
    [
      aws_subnet.easycrud_public_1.id,
      aws_subnet.easycrud_public_2.id
    ],
    count.index
  )

  associate_public_ip_address = true

  user_data = file("/root/terraform/EasyCRUD_AWS/user.sh")

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name = "public_instance-${count.index + 1}"
  }
}

# Private EC2 Instance
resource "aws_instance" "private_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  subnet_id = aws_subnet.easycrud_private_app_1.id

  user_data = file("/root/terraform/EasyCRUD_AWS/user.sh")

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name = "private_instance"
  }
}