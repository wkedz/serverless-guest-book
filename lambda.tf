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