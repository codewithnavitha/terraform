output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "private_key_path" {
  value = local_sensitive_file.private_key.filename
}

output "ssh_command" {
  value = "ssh -i \"${local_sensitive_file.private_key.filename}\" ec2-user@${aws_instance.this.public_ip}"
}