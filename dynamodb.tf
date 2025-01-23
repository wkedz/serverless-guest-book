module "dynamodb" {
  source = "./modules/dynamodb"

  for_each = var.dynamodb_tables

  table_name     = each.key
  hash_key       = each.value.hash_key
  hash_key_type  = each.value.hash_key_type
  billing_mode   = each.value.billing_mode
  read_capacity  = each.value.read_capacity
  write_capacity = each.value.write_capacity
}