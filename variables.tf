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

variable "application" {
  type = string
}

variable "iam_roles" {
  type = map(object({
    trust_relationship_principals = map(set(string))
    attach_policy                 = string
  }))
}

variable "dynamodb_tables" {
  type = map(object({
    hash_key       = string
    hash_key_type  = string
    billing_mode   = string
    read_capacity  = number
    write_capacity = number
  }))
}

variable "s3_buckets" {
  type = map(object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
    bucket_policy = optional(map(object({
      effect     = string
      actions    = set(string)
      resources  = set(string)
      principals = map(set(string))
    })))
  }))
}
