variable "name" {
    type = string
    description = "Name of policy"
}

variable "statements" {
    type = map(object({
      effect = string
      actions = set(string)
      resources = set(string)
    }))
}