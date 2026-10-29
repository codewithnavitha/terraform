variable "aws_region" {
  description = "AWS region for the EC2 instance"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}
variable "key_name" {
  description = "Name for the generated EC2 SSH key pair"
  type        = string
  default     = "terraform-key"
}

variable "ssh_cidr" {
  description = "IPv4 CIDR allowed to connect to the instance over SSH"
  type        = string
  default     = "54.210.44.78/32"

  validation {
    condition     = can(cidrnetmask(var.ssh_cidr))
    error_message = "ssh_cidr must be a valid IPv4 CIDR, such as 203.0.113.8/32."
  }
}
