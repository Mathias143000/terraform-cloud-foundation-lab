locals {
  tags = {
    project     = "terraform-cloud-foundation-lab"
    scope       = "bootstrap"
    managed_by  = "terraform"
    environment = "shared"
  }
}

module "remote_state" {
  source          = "../modules/remote_state"
  bucket_name     = var.state_bucket_name
  lock_table_name = var.state_lock_table_name
  tags            = local.tags
}
