module "s3_website_configuration" {
  source = "./modules/s3_website_deployment"

  for_each = var.websites

  bucket_id = module.s3_bucket[each.key].bucket_id
  index_name = each.value.index_name
  website_files_directory = each.value.website_files_directory
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