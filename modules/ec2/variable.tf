variable "ec2_ami" {}
variable "instance_type" {}
variable "vpc_id" {}
variable "pub_subnet" {
    type = list(string)
}
variable "security_group_ids" {
    type = list(string)
}
variable "key_name" {}
variable "resource_name" {}
variable "ec2_iam_roles" {
    type = list(map(string))
}