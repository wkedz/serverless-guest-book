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
}