resource "aws_apigatewayv2_api" "api" {
    name          = var.api_gateway_name
    protocol_type = "HTTP"
    cors_configuration {
        allow_origins = var.cors_origins
    }
}

resource "aws_apigatewayv2_stage" "stage" {
    api_id      = aws_apigatewayv2_api.api.id
    name        = "$default"
    auto_deploy = true
}

resource "aws_apigatewayv2_integration" "intergration" {
    api_id = aws_apigatewayv2_api.api.id
    # Because we want to access another resource we need to use AWS_PROXY
    integration_type = "AWS_PROXY"
    # Because we are accessing api gateway from inthernet. For inthranet use VPC_LINK.
    connection_type        = "INTERNET"
    integration_method     = "POST"
    integration_uri        = var.lambda_invoke_arn #module.lambda["backend"].invoke_arn
    payload_format_version = var.lambda_payload_version
}

resource "aws_apigatewayv2_route" "route" {
    for_each = var.routes

    api_id    = aws_apigatewayv2_api.api.id
    route_key = each.value
    target    = "integrations/${aws_apigatewayv2_integration.intergration.id}"
}