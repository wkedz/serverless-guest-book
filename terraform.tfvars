# API Gateway
api_gateway_name = "backend"
api_gateway_route_get = {
  http_method = "GET"
  route       = "/"
}
api_gateway_route_post = {
  http_method = "POST"
  route       = "/"
}
lambda_payload_version = "2.0"

# Lambda
lambda_role_name        = "backend-lambda-role"
lambda_source_dir       = "./backend"
lambda_source_file_name = "backend"
lambda_function_name    = "backend"
lambda_handler_name     = "main.handler"

# Buckets
main_bucket_name = "frontend-terraform-demo"
main_bucket_public_access_block = {
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}
application = "client"

# Roles
iam_roles = {
  backend-lambda-role = {
    trust_relationship_principals = {
      Service = ["lambda.amazonaws.com"]
    }
    attach_policy = "backend-lambda-policy"
  }
}

# Dynamodb

dynamodb_tables = {
  comments = {
    hash_key       = "mail"
    hash_key_type  = "string"
    billing_mode   = "provisioned"
    write_capacity = 1
    read_capacity  = 1
  }
}