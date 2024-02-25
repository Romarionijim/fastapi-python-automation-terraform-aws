variable "cidr_blocks_object" {
  type = list(object({
    name       = string
    cidr_block = string
  }))
}

variable "env_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}
