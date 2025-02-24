

variable "vpcs" {
  description = "Map of VPCs to create"
  type = map(object({
    cidr = string
  }))
}

variable "pub_subnets" {
  description = "List of public subnets"
  type = list(object({
    vpc_name          = string
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "pri_subnets" {
  description = "List of private subnets"
  type = list(object({
    vpc_name          = string
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

