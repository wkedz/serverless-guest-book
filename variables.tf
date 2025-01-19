# API Gateway
variable "api_gateway_name" {
  type        = string
  description = "This is a name of API Gateway."
  default     = "backend"
  # Should it be displayed in output
  sensitive = false
  # Can be or not null
  nullable = false
  #ephemeral = false
  #   validation {
  #   }
}

variable "lambda_payload_version" {
  type        = string
  description = "Payload version of backend lambda."
  default     = "2.0"
  nullable    = false
}

variable "api_gateway_route_get" {
  type = object({
    http_method = string
    route       = string
  })
  description = "GET route of API Gateway"
}

variable "api_gateway_route_post" {
  type = object({
    http_method = string
    route       = string
  })
  description = "POST route of API Gateway"
}

# DynamoDB
variable "dynamodb_table_name" {
  type        = string
  description = "Name of DynamoDB table"
  nullable    = false
}

variable "dynamodb_hash_key_name" {
  type        = string
  description = "Name of DynamoDB hash key"
  nullable    = false
}

variable "dynamodb_read_capacity" {
  type        = number
  description = "Value of read capacity of DynamoDB"
  default     = 1
  nullable    = false
}

variable "dynamodb_write_capacity" {
  type        = number
  description = "Value of write capacity of DynamoDB"
  default     = 1
  nullable    = false
}

# Lambda
variable "lambda_policy_name" {
  type        = string
  description = "Name of policy used by Lambda"
  nullable    = false
}

variable "lambda_role_name" {
  type        = string
  description = "Name of role used by Lambda"
  nullable    = false
}

variable "lambda_source_dir" {
  type        = string
  description = "Path to Lambda code"
  nullable    = false
}

variable "lambda_source_file_name" {
  type        = string
  description = "Source filename of Lambda code"
  default     = "backend"
  nullable    = false
}

variable "lambda_function_name" {
  type        = string
  description = "Name of Lambda function"
  default     = "backend"
  nullable    = false
}

variable "lambda_handler_name" {
  type        = string
  description = "Name of handler Lambda function"
  default     = "main.handler"
  nullable    = false
}

# Buckets
variable "main_bucket_name" {
  type        = string
  description = "Name of the bucket storing frontend data"
  default     = "frontend-terraform-demo"
  nullable    = false
}

variable "main_bucket_public_access_block" {
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  description = "Public access policy of main s3 bucket"
  default = {
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = false
  }
  nullable = false
}

variable "application" {
  type = string
}