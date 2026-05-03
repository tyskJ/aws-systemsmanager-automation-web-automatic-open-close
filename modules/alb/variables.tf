variable "vpc_id" {
  type = string
}

variable "instance_id" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "sg_id" {
  type = string
}

variable "region" {
  type = string
}