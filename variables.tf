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
  type = string
  description = "Payload version of backend lambda."
  default = "2.0"
  nullable = false
}

variable "api_gateway_route_get" {
  type = object({
    http_method = string
    route = string
  })
  description = "GET route of API Gateway"
}

variable "api_gateway_route_post" {
  type = object({
    http_method = string
    route = string
  })
  description = "POST route of API Gateway"
}