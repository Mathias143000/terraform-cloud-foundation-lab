variable "environment" {
  type = string
}

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
  type      = string
  default   = "test"
  sensitive = true
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "admin_cidr_blocks" {
  type = list(string)
}

variable "db_endpoint_host" {
  type = string
}

variable "db_endpoint_port" {
  type = number
}
