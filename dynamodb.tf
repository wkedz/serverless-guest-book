resource "aws_dynamodb_table" "dynamodb_table" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table#argument-reference
  name     = var.dynamodb_table_name
  hash_key = var.dynamodb_hash_key_name

  attribute {
    name = var.dynamodb_hash_key_name
    type = "S"
  }

  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
}