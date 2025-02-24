output "vpc_ids" {
  value = module.vpc.vpc_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "internet_gateway_ids" {
  value = module.vpc.internet_gateway_ids
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}
output "api_gateway_execution_arn" {
    value = module.apigateway.api_gateway_endpoint
}

output "lambda_function_arns" {
    value = module.lambda.lambda_invoke_arns
}
output "lambda_invoke_urls_debug" {
  value = module.lambda.lambda_function_names
}
output "api_gateway_endpoint" {
    value = module.apigateway.api_gateway_endpoint
  
}

output "lambda_invoke_arns" {
    value = module.lambda.lambda_invoke_arns
}