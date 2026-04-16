resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = true
  user_data                   = var.user_data

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app"
    Role = "app-host"
  })
}
