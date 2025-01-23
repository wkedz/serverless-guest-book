locals {
  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "text/javascript"
  }

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
        source_arn   = "${aws_apigatewayv2_api.api.execution_arn}/*"
      }
    }
  }
}