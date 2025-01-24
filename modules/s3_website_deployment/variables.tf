variable "bucket_id" {
  type = string
  nullable = false
}

variable "index_name" {
  type = string
  nullable = false
  default = "index.html"
}

variable "website_files_directory" {
  type = string
  nullable = false
}
