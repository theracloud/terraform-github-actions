terraform {
  backend "s3" {
    bucket         = "rahaman-terraform-state"
    key            = "terraform-github-actions/terraform.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "rahaman-terraform-locks"  ← deprecated
    use_lockfile   = true
    encrypt        = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# main.tf
provider "aws" {
  region = var.region
}


locals {
  common_tags = {
    Owner   = "DevOps Engineer"
    Project = "web-server-${var.environment}"
    Env     = var.environment
    Builder = "terraform"
  }
}

resource "aws_instance" "web-instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  user_data                   = <<-EOF
    #!/bin/bash
    echo "Hello, World. You are on a ${var.environment} server" > index.html
    nohup busybox httpd -f -p 80 &
    EOF
  user_data_replace_on_change = true

  tags = merge(
    local.common_tags,
    {
      Name = "web-server-${var.environment}"
    }
  )

}

resource "aws_security_group" "web-sg" {
  name_prefix = "web-sg-"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

output "instance_public_ip" {
  description = "IP publique de l'instance EC2"
  value       = aws_instance.web-instance.public_ip
}
