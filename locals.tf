locals {
  iam_polices = {
    backend-lambda-policy = {
      ReadWriteDynamoDB = {
        effect = "Allow"
        actions = [
          "dynamoDB:Scan",
          "dynamoDB:PutItem",
        ]
        resources = [
          module.dynamodb["comments"].table_arn
        ]
      }
      AllowLogging = {
        effect = "Allow"
        actions = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        resources = ["*"]
      }
    }
  }

  lambda_functions = {
    backend = {
      code_dir       = "./backend"
      function_name  = "backend"
      handler_name   = "main.handler"
      execution_role = "backend-lambda-role"
      runtime_env    = "python3.8"
      environment_variables = {
        TABLE_NAME = module.dynamodb["comments"].table_name
      }
      permissions = {
        statement_id = "HTTPApiInvoke"
        principal    = "apigateway.amazonaws.com"
        source_arn   = "${module.api_gateway["backend"].execution_arn}/*"
      }
    }
  }

  api_gateways = {
    backend = {
      cors_origins = [
        "http://${module.s3_website_configuration["frontend-terraform-demo"].website_endpoint}"
      ]
      lambda_invoke_arn = module.lambda["backend"].invoke_arn
      lambda_payload_version = var.lambda_payload_version
      routes = ["GET /", "POST /"]
    }
  }
}