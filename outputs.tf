output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "ssh_command" {
  description = "Command to connect to the instance from this machine"
  value       = module.ec2_instance.ssh_command
}

output "private_key_path" {
  description = "Local path to the generated SSH private key; keep this file secret"
  value       = module.ec2_instance.private_key_path
}