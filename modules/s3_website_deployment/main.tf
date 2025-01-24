resource "aws_s3_bucket_website_configuration" "website" {
  bucket = var.bucket_id

  index_document {
    suffix = var.index_name
  }
}

resource "aws_s3_object" "name" {
  for_each     = fileset(var.website_files_directory, "**")
  bucket       = var.bucket_id
  key          = each.value
  source       = "${var.website_files_directory}/${each.value}"
  etag         = filemd5("${var.website_files_directory}/${each.value}")
  content_type = lookup(local.mime_types, regex("[^.]+$", each.value), null)
}