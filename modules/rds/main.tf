resource "terraform_data" "this" {
  input = {
    identifier        = "${var.name_prefix}-postgres"
    engine            = "postgres"
    engine_version    = var.engine_version
    instance_class    = var.instance_class
    allocated_storage = var.allocated_storage
    db_name           = var.db_name
    username          = var.username
    endpoint_host     = var.endpoint_host
    endpoint_port     = var.endpoint_port
    mode              = "local-rds-emulation"
  }
}
