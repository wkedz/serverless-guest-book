resource "aws_dynamodb_table" "dynamodb_table" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table#argument-reference
  name     = var.table_name
  hash_key = var.hash_key

  attribute {
    name = var.hash_key
    # We will look in dynamodb_types for a specyfic type, given on the user input.
    # If not found, it will return S.
    type = lookup(local.dynamodb_types, var.hash_key_type, "S")
  }

  billing_mode   = upper(var.billing_mode)
  read_capacity  = upper(var.billing_mode) == "PROVISIONED" ? var.read_capacity : null
  write_capacity  = upper(var.billing_mode) == "PROVISIONED" ? var.write_capacity : null
}