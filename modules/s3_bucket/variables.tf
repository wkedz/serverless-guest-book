variable "bucket_name" {
  type     = string
  nullable = false
}

variable "block_public_acls" {
  type     = bool
  nullable = false
  default  = true
}

variable "block_public_policy" {
  type     = bool
  nullable = false
  default  = true
}

variable "ignore_public_acls" {
  type     = bool
  nullable = false
  default  = true
}

variable "restrict_public_buckets" {
  type     = bool
  nullable = false
  default  = true
}

variable "bucket_policy" {
  type = map(object({
        effect = string
        actions = set(string)
        resources = set(string)
        principals = map(set(string))
  }))
  nullable = true
  default = null
}