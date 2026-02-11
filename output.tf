# Output to display the private IP address of the EC2 instance
output "instance_ip_addr" {
  value       = aws_instance.my_server.private_ip
  description = "The private IP address of the EC2 instance"
}

# REQUIREMENT #2: Output the public IP address
output "public_ip" {
  value       = aws_instance.my_server.public_ip
  description = "The public IP address of the EC2 instance - use this to access WordPress"
}
