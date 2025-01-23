variable "table_name" {
  type = string
}

variable "hash_key" {
  type = any # because hash key can be number, string or binary
}

variable "hash_key_type" {
  type = string # because hash key can be N, S or B
}

variable "billing_mode" {
  type = string
  default = "PAY_PER_REQUEST"
  description = "Set bliing moge of dynamodb. If PAY_PER_REQUEST, we do not need to set write/read capacity."
}

variable "read_capacity" {
  type = number
  default = null
}

variable "write_capacity" {
  type = number
  default = null
}