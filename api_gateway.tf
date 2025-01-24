module "api_gateway" {
  source = "./modules/api_gateway"

  for_each = local.api_gateways

  api_gateway_name = each.key
  cors_origins = each.value.cors_origins
  lambda_invoke_arn = each.value.lambda_invoke_arn
  lambda_payload_version = each.value.lambda_payload_version
  routes = each.value.routes
}