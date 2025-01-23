output "table_arn" {
    value = aws_dynamodb_table.dynamodb_table.arn
    description = "ARN of created dynamodb."
}

output "table_name" {
    value = aws_dynamodb_table.dynamodb_table.name
    description = "Name of table."
}