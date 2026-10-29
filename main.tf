terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}



provider "aws" {
  region = var.aws_region
}

module "ec2_instance" {
  source           = "./modules/EC2"
  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  key_name         = var.key_name
  ssh_cidr         = var.ssh_cidr
}



