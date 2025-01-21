variable "trust_relationship_principals" {
    type = map(set(string))
}

variable "name" {
    type = string
}

variable "policy_arn" {
    type = string
}