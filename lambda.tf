resource "aws_iam_policy" "policy" {
  name   = var.lambda_policy_name
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role" "role" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "lambda_backend" {
  filename      = "./${var.lambda_source_file_name}.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.role.arn
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

data "aws_iam_policy_document" "policy" {
  dynamic "statement" {
    for_each = local.lambda_policy
    content {
      sid       = statement.key
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
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