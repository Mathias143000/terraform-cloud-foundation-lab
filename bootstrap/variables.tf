variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_endpoint" {
  type    = string
  default = "http://localstack:4566"
}

variable "aws_access_key" {
  type    = string
  default = "test"
}

variable "aws_secret_key" {
  type    = string
  default = "test"
}

variable "state_bucket_name" {
  type    = string
  default = "terraform-cloud-foundation-state"
}

variable "state_lock_table_name" {
  type    = string
  default = "terraform-cloud-foundation-locks"
}
