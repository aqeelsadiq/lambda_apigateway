locals {
  lambda_map = { for lambda in var.lambda_functions : lambda.function_name => lambda }
}

resource "aws_iam_role" "lambda_role" {
  for_each = local.lambda_map

  name = each.value.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_ec2_policy" {
  for_each = local.lambda_map
  name        = each.value.iam_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = split(",", each.value.ec2_actions)
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ec2_attach" {
  for_each = local.lambda_map
  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = aws_iam_policy.lambda_ec2_policy[each.key].arn
}

data "archive_file" "zip_the_python_code" {
  for_each = local.lambda_map

  type        = "zip"
  source_dir  = "${path.module}/function/"
  output_path = "${path.module}/function/${each.key}.zip"
}

resource "aws_lambda_function" "lambda" {
  for_each = local.lambda_map

  function_name = each.key
  role          = aws_iam_role.lambda_role[each.key].arn
  handler       = each.value.handler
  runtime       = each.value.runtime
  filename      = "${path.module}/function/${each.key}.zip"
  timeout       = tonumber(each.value.timeout)

  depends_on = [aws_iam_role_policy_attachment.lambda_ec2_attach]
}

resource "aws_lambda_permission" "invoke_lambda" {
  for_each = local.lambda_map
  statement_id  = var.statement_id
  action        = var.action
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = var.principle
}
resource "aws_lambda_function_url" "lambda_url" {
  for_each      = aws_lambda_function.lambda
  function_name = each.value.function_name
  authorization_type = "NONE"
}
