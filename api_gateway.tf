resource "aws_apigatewayv2_api" "api" {
  name          = "backend"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "intergration" {
  api_id = aws_apigatewayv2_api.api.id
  # Because we want to access another resource we need to use AWS_PROXY
  integration_type = "AWS_PROXY"
  # Because we are accessing api gateway from inthernet. For inthranet use VPC_LINK.
  connection_type    = "INTERNET"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.lambda_backend.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "route_get" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.intergration.id}"
}

resource "aws_apigatewayv2_route" "route_post" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.intergration.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}