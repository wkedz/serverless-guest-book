resource "aws_s3_object" "name" {
  for_each     = fileset("./frontend/build", "**")
  bucket       = module.s3_bucket["frontend-terraform-demo"].bucket_id
  key          = each.value
  source       = "./frontend/build/${each.value}"
  etag         = filemd5("./frontend/build/${each.value}")
  content_type = lookup(local.mime_types, regex("[^.]+$", each.value), null)
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = module.s3_bucket["frontend-terraform-demo"].bucket_id

  index_document {
    suffix = var.application == "client" ? "index.html" : "index2.html"
  }
}

module "s3_bucket" {
  source = "./modules/s3_bucket"

  for_each = var.s3_buckets

  bucket_name             = each.key
  block_public_acls       = each.value.block_public_acls
  block_public_policy     = each.value.block_public_policy
  ignore_public_acls      = each.value.ignore_public_acls
  restrict_public_buckets = each.value.restrict_public_buckets
  bucket_policy           = each.value.bucket_policy
}