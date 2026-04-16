variable "name_prefix" {
  type = string
}

variable "db_name" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "endpoint_host" {
  type = string
}

variable "endpoint_port" {
  type = number
}

variable "tags" {
  type = map(string)
}
