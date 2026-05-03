variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "igw_id" {
  type = string
}

variable "ngw_id" {
  type = string
}