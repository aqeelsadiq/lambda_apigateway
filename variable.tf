variable "aws_region" {}
variable "resource_name" {}
variable "ec2_ami" {}
variable "instance_type" {}
variable "key_name" {}


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

variable "security_group" {
  type = list(map(string))
}
variable "lambda_functions" {
  type = list(map(string))
}
variable "ec2_iam_roles" {
  type = list(map(string))
}

variable "action" {}
variable "principle" {}
variable "statement_id" {}


variable "api_name" {}
variable "protocol_type" {}
variable "integration_type" {}
variable "auto_deploy" {}
variable "lambda_action" {}
variable "lambda_principal" {}
