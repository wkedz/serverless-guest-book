resource "aws_iam_policy" "policy" {
  name   = "backend-lambda-policy"
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role" "role" {
  name               = "backend-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "lambda_backend" {
  filename      = "./backend.zip"
  function_name = "backend"
  role          = aws_iam_role.role.arn
  # Name of the function that handles event
  handler = "main.handler"
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
  statement {
    sid    = "ReadWriteDynamoDB"
    effect = "Allow"
    actions = [
      "dynamoDB:Scan",
      "dynamoDB:PutItem",
    ]
    resources = [
      aws_dynamodb_table.dynamodb_table.arn
    ]
  }

  statement {
    sid    = "AllowLogging"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
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
  output_path = "./backend.zip"
  source_dir  = "./backend"
}

resource "aws_lambda_permission" "resource_based_policy" {
  statement_id  = "HTTPApiInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*"
}