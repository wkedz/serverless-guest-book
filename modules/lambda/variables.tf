variable "code_dir" {
  type     = string
  nullable = false
}

variable "function_name" {
  type     = string
  nullable = false
}

variable "handler_name" {
  type     = string
  nullable = false
}

variable "execution_role_arn" {
  type     = string
  nullable = false
}

variable "runtime_env" {
  type     = string
  nullable = false
  default  = "python3.8"
}

variable "environment_variables" {
  type     = map(string)
  nullable = false
  default = {
  }
}

variable "permissions" {
  type = object({
    statement_id = string
    principal    = string
    source_arn   = string
  })
}