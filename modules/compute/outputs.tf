output "instance_id" {
  value = aws_instance.app.id
}

output "private_ip" {
  value = try(aws_instance.app.private_ip, null)
}

output "public_ip" {
  value = try(aws_instance.app.public_ip, null)
}
