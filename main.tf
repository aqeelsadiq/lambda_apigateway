#####################################
#  MODULES
#####################################

module "vpc" {
  source = "./modules/vpc"

  vpcs = var.vpcs
  pub_subnets = var.pub_subnets
  pri_subnets = var.pri_subnets

}

####################################
# Security Group
####################################
module "sg" {
  source         = "./modules/sg"
  vpc_id         = module.vpc.vpc_ids
  resource_name  = var.resource_name
  security_group = var.security_group
}


#####################################
#  EC2
#####################################
module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = module.vpc.vpc_ids
  security_group_ids = module.sg.security_group_ids
  resource_name      = var.resource_name
  ec2_ami            = var.ec2_ami
  instance_type      = var.instance_type
  key_name           = var.key_name
  pub_subnet         = values(module.vpc.public_subnet_ids)
  ec2_iam_roles = var.ec2_iam_roles


}

######################################
# lambda
######################################

module "lambda" {
  source           = "./modules/lambda"
  lambda_functions = var.lambda_functions
  action           = var.action
  principle        = var.principle
  statement_id     = var.statement_id

}



##########################################
#  apigateway
##########################################

module "apigateway" {
  source           = "./modules/apigateway"
  api_name         = var.api_name
  protocol_type    = var.protocol_type
  lambda_action    = var.lambda_action
  lambda_principal = var.lambda_principal
  auto_deploy      = var.auto_deploy
  integration_type = var.integration_type
  lambda_invoke_arns  = module.lambda.lambda_invoke_arns
  lambda_function_names = module.lambda.lambda_function_names

}




