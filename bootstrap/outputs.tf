output "state_bucket_name" {
  value = module.remote_state.bucket_name
}

output "state_lock_table_name" {
  value = module.remote_state.lock_table_name
}
