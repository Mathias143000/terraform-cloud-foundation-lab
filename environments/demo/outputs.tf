output "environment" {
  value = var.environment
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "app_instance_id" {
  value = module.compute.instance_id
}

output "app_private_ip" {
  value = module.compute.private_ip
}

output "app_public_ip" {
  value = module.compute.public_ip
}

output "db_identifier" {
  value = module.rds.db_identifier
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "iam_role_name" {
  value = module.iam.role_name
}
