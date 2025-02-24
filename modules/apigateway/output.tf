
output "api_gateway_endpoint" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/start-multiple-ec2"
}
