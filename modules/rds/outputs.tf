output "db_identifier" {
  value = terraform_data.this.output.identifier
}

output "db_endpoint" {
  value = "${terraform_data.this.output.endpoint_host}:${terraform_data.this.output.endpoint_port}"
}

output "db_name" {
  value = terraform_data.this.output.db_name
}
