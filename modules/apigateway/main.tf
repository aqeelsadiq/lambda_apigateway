resource "aws_apigatewayv2_api" "http_api" {
  name          = var.api_name
  protocol_type = var.protocol_type
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  for_each        = var.lambda_function_names
  api_id          = aws_apigatewayv2_api.http_api.id
  integration_type = var.integration_type
  integration_uri  = var.lambda_invoke_arns[each.key]
}

resource "aws_apigatewayv2_route" "lambda_route" {
  for_each  = var.lambda_function_names
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /${each.key}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration[each.key].id}"
}

resource "aws_apigatewayv2_stage" "http_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = var.auto_deploy
}

resource "aws_lambda_permission" "apigateway_invoke_lambda" {
  for_each      = var.lambda_function_names
  statement_id  = "AllowExecutionFromAPIGatewayStart"
  action        = var.lambda_action
  function_name = each.value
  principal     = var.lambda_principal
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
