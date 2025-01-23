data "archive_file" "lambda_package" {
  type        = "zip"
  output_path = "${var.code_dir}.zip"
  source_dir  = var.code_dir
}

resource "aws_lambda_function" "lambda_backend" {
  filename      = "${var.code_dir}.zip"
  function_name = var.function_name
  role          = var.execution_role_arn #module.iam_roles["backend-lambda-role"].arn
  # Name of the function that handles event
  handler = var.handler_name
  runtime = var.runtime_env

  # Update new function, if we update the source code
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  environment {
    variables = var.environment_variables
    #   {
    #   TABLE_NAME = module.dynamodb["comments"].table_name
    # }
  }
}

resource "aws_lambda_permission" "resource_based_policy" {
  statement_id  = var.permissions.statement_id #"HTTPApiInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_backend.function_name
  # principal and source_arn are corelated 
  principal  = var.permissions.principal  #"apigateway.amazonaws.com"
  source_arn = var.permissions.source_arn #"${aws_apigatewayv2_api.api.execution_arn}/*"
}