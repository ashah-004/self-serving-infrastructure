terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }

    local = {
        
        source = "hashicorp/local"
        version = "~> 2.4"
    }
  }
}

variable "aws_region" {
    description = "The AWS region to deploy to."
    type = string
}

variable "user_name" {
    description = "Tag for who created the resource."
    type = string
}

variable "key_name" {
    description = "The AWS EC2 key pair name to use for ssh."
    type = string
}

variable "security_group_id" {
  description = "The AWS security group id attached to the VM."
  type = string
}

provider "aws" {
    region = var.aws_region
}

data "aws_ssm_parameter" "amazon_linux_2" {
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "web" {
    ami = data.aws_ssm_parameter.amazon_linux_2.value
    instance_type = "t2.micro"

    key_name = var.key_name
    vpc_security_group_ids = [var.security_group_id]

    root_block_device {
        volume_size = 8
    }

    tags = {
        Name = "kestra-dev-vm"
        Owner = var.user_name
        Purpose = "ephemeral-test"
    }
}

resource "local_file" "vm_ip_file" {
    content = aws_instance.web.public_ip
    filename = "ip.txt"
}


