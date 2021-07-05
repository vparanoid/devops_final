variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "public_subnet" {
  default = "10.10.11.0/24"
}

variable "az" {
  default = ""
}

variable "env" {
  default = ""
}