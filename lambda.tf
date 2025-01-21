resource "aws_lambda_function" "lambda_backend" {
  filename      = "./${var.lambda_source_file_name}.zip"
  function_name = var.lambda_function_name
  role          = module.iam_roles["backend-lambda-role"].arn
  # Name of the function that handles event
  handler = var.lambda_handler_name
  runtime = "python3.8"

  # Update new function, if we update the source code
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.dynamodb_table.name
    }
  }
}

data "archive_file" "lambda_package" {
  type        = "zip"
  output_path = "./${var.lambda_source_file_name}.zip"
  source_dir  = var.lambda_source_dir
}

resource "aws_lambda_permission" "resource_based_policy" {
  statement_id  = "HTTPApiInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*"
}

module "iam_policy" {
  source = "./modules/iam_policy"

  for_each = local.iam_polices

  name       = each.key
  statements = each.value
}

module "iam_roles" {
  source = "./modules/iam_role"

  for_each = var.iam_roles

  name = each.key
  trust_relationship_principals = each.value.trust_relationship_principals
  policy_arn = module.iam_policy[each.value.attach_policy].policy_arn
}