variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_cidr_1" {
    default = "10.0.1.0/24"
}
variable "public_cidr_2" {
    default = "10.0.2.0/24"
}
variable "public_az_1" {
    default = "ap-south-1a"
}
variable "public_az_2" {
    default = "ap-south-1b"
}

variable "private_cidr_1" {
    default = "10.0.11.0/24"
}
variable "private_cidr_2" {
    default = "10.0.12.0/24"
}
variable "private_az_1" {
    default = "ap-south-1a"
}
variable "private_az_2" {
    default = "ap-south-1b"
}

variable "private_db_cidr_1" {
    default = "10.0.21.0/24"
}
variable "private_db_cidr_2" {
    default = "10.0.22.0/24"
}
variable "private_db_az_1" {
    default = "ap-south-1a"
}
variable "private_db_az_2" {
    default = "ap-south-1b"
}

variable "ami" {
    default = "ami-01a00762f46d584a1"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key_name" {
    default = "lokey"
}

variable "volume_size" {
    default = 10
}

variable "volume_type" {
    default = "gp3"
}