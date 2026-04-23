locals {
  name_prefix = "foundation-${var.environment}"
  tags = {
    project     = "terraform-cloud-foundation-lab"
    managed_by  = "terraform"
    environment = var.environment
  }
}

module "network" {
  source               = "../../modules/network"
  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = local.tags
}

module "security" {
  source            = "../../modules/security"
  name_prefix       = local.name_prefix
  vpc_id            = module.network.vpc_id
  admin_cidr_blocks = var.admin_cidr_blocks
  tags              = local.tags
}

module "iam" {
  source      = "../../modules/iam"
  name_prefix = local.name_prefix
  tags        = local.tags
}

module "compute" {
  source                = "../../modules/compute"
  name_prefix           = local.name_prefix
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  subnet_id             = module.network.public_subnet_ids[0]
  security_group_ids    = [module.security.app_security_group_id]
  instance_profile_name = module.iam.instance_profile_name
  user_data             = <<-EOT
    #!/bin/bash
    echo "foundation-${var.environment}" > /etc/motd
  EOT
  tags                  = local.tags
}

module "rds" {
  source             = "../../modules/rds"
  name_prefix        = local.name_prefix
  db_name            = var.db_name
  engine_version     = var.db_engine_version
  instance_class     = var.db_instance_class
  allocated_storage  = var.db_allocated_storage
  username           = var.db_username
  password           = var.db_password
  subnet_ids         = module.network.private_subnet_ids
  security_group_ids = [module.security.db_security_group_id]
  endpoint_host      = var.db_endpoint_host
  endpoint_port      = var.db_endpoint_port
  tags               = local.tags
}
