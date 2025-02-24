variable "vpc_id" {
  type =map(string)
}
variable "resource_name" {}
variable "security_group" {
  type = list(map(string))
}
