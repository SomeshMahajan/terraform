variable "load_balancer_type" {
    default = "application"
}

variable "load_balancer_arn" {
    default = "aws_lb.lb.arn"
}

variable "target_group_arn" {
    default = "aws_lb_target_group.tg.arn"
}

variable "lb_listener_port" {
    default = "80"
}

variable "lb_listener_protocol" {
    default = "HTTP"
}

varialbe "image_id" {
    default = "ami-01a00762f46d584a1"
}

variable "key_name" {
    default = "lokey"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "desired_capacity" {
    default = "2"
}

variable "min_size" {
    default = "2"
}

variable "max_size" {
    default = "10"
} 

