variable "api_gateway_name" {
  type     = string
  nullable = false
}

variable "cors_origins" {
  type    = set(string)
  default = null
}

variable "lambda_payload_version" {
  type     = string
  nullable = false
  default  = "2.0"
}

variable "routes" {
  type     = set(string)
  nullable = false
}

variable "lambda_name" {
  type     = string
  nullable = false
}