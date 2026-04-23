variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "admin_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed to reach administrative ports in the lab."
}

variable "tags" {
  type = map(string)
}
