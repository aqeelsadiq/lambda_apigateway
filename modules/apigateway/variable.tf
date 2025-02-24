
variable "api_name" {}
variable "protocol_type" {}
variable "integration_type" {}
variable "lambda_invoke_arns" {
  type = map(string)
}
variable "lambda_function_names" {
  type = map(string)
}
variable "auto_deploy" {}
variable "lambda_action" {}
variable "lambda_principal" {}


