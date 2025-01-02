resource "aws_s3_bucket" "bucket_frontend" {
  bucket = "frontend-terraform-demo"
}

resource "aws_s3_bucket_public_access_block" "bucket_frontend_public_access" {
  bucket = aws_s3_bucket.bucket_frontend.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false

# Only if we give raw name of bucket:
# bucket = "frontend-terraform-demo"
#   depends_on = [ 
#     aws_s3_bucket.bucket_frontend
#   ]
# If we use attribute that is returned (for example id check https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#attribute-reference)
# we then do not need dependencies
}