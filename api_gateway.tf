module "api_gateway" {
  source = "./modules/api_gateway"

  for_each = local.api_gateways

  api_gateway_name = each.key
  cors_origins = each.value.cors_origins
  lambda_name = each.value.lambda_name
  lambda_payload_version = each.value.lambda_payload_version
  routes = each.value.routes
}

