aws_region    = "us-west-1"
resource_name = "demo-aqeel1"
ec2_ami       = "ami-07d2649d67dbe8900"      #ami-00c257e12d6828491
instance_type = "t2.micro"
key_name      = "testec2-aq"



##############################
# EC2 Iam Roles
#############################

ec2_iam_roles = [
  {
    role_name  = "EC2FullAccessRole"
    principal  = "ec2.amazonaws.com"
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  }
  # {
  #   role_name  = "S3AccessRole"
  #   principal  = "ec2.amazonaws.com"
  #   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  # }
]

###############################
# vpc and subnets
###############################

vpcs = {
  dev-vpc = {
    cidr = "10.0.0.0/16"
  }
  # prod-vpc = {
  #   cidr = "10.1.0.0/16"
  # }
}

pub_subnets = [
  {
    vpc_name          = "dev-vpc"
    name              = "dev-public-1"
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-west-1a"
  }
  # {
  #   vpc_name          = "prod-vpc"
  #   name              = "prod-public-1"
  #   cidr_block        = "10.1.1.0/24"
  #   availability_zone = "us-west-1b"
  # }
]

pri_subnets = [
  {
    vpc_name          = "dev-vpc"
    name              = "dev-private-1"
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-west-1a"
  }
  # {
  #   vpc_name          = "prod-vpc"
  #   name              = "prod-private-1"
  #   cidr_block        = "10.1.2.0/24"
  #   availability_zone = "us-west-1b"
  # }
]


####################################
# Security Groups
####################################

security_group = [
  {
    name        = "webserver-sg"
    description = "Allow HTTP and HTTPS"
    ports       = "80,443,22"
    cidr_blocks = "0.0.0.0/0"
    vpc_name = "dev-vpc"
  }
  # {
  #   name         = "db-sg"
  #   description  = "Allow SSH"
  #   ports        = "3306"
  #   cidr_blocks  = "0.0.0.0/0"
  # }
]


######################################
# lambda function
######################################

statement_id = "AllowExecutionFromAPI"
action       = "lambda:InvokeFunction"
principle    = "apigateway.amazonaws.com"


lambda_functions = [
  {
    function_name   = "start-multiple-ec2"
    runtime         = "python3.9"
    timeout         = "30"
    handler         = "lambda_function.lambda_handler"
    iam_role_name   = "lambda-ec2-start-role"
    iam_policy_name = "LambdaEC2ControlPolicy"
    ec2_actions     = "ec2:StartInstances,ec2:DescribeInstances,ec2:StopInstances"
  }
  # {
  #   function_name   = "stop-multiple-ec2"
  #   runtime        = "python3.9"
  #   timeout        = "30"
  #   handler        = "lambda_function.lambda_handler"
  #   iam_role_name  = "lambda-ec2-stop-role"
  #   iam_policy_name = "LambdaEC2StopControlPolicy"
  #   ec2_actions    = "ec2:StopInstances,ec2:DescribeInstances"
  # }
]



###############################
# api gateway 
###############################

api_name         = "ec2-api"
protocol_type    = "HTTP"
integration_type = "AWS_PROXY"
auto_deploy      = true
lambda_action    = "lambda:InvokeFunction"
lambda_principal = "apigateway.amazonaws.com"
