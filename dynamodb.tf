resource "aws_dynamodb_table" "dynamodb_table" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table#argument-reference
  name     = "comments"
  hash_key = "mail"

  attribute {
    name = "mail"
    type = "S"
  }

  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
}