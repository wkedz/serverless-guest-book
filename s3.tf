resource "aws_s3_bucket" "bucket_frontend" {
  bucket = var.main_bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_frontend_public_access" {
  bucket = aws_s3_bucket.bucket_frontend.id

  block_public_acls       = var.main_bucket_public_access_block.block_public_acls
  block_public_policy     = var.main_bucket_public_access_block.block_public_policy
  ignore_public_acls      = var.main_bucket_public_access_block.ignore_public_acls
  restrict_public_buckets = var.main_bucket_public_access_block.restrict_public_buckets

  # Only if we give raw name of bucket:
  # bucket = "frontend-terraform-demo"
  #   depends_on = [ 
  #     aws_s3_bucket.bucket_frontend
  #   ]
  # If we use attribute that is returned (for example id check https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#attribute-reference)
  # we then do not need dependencies
}

data "aws_iam_policy_document" "bucket_frontend_policy" {
  statement {
    sid     = "AllowPublic"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    # Reference in string to resource 
    resources = ["${aws_s3_bucket.bucket_frontend.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "bucket_frontend_policy" {
  bucket = aws_s3_bucket.bucket_frontend.id
  policy = data.aws_iam_policy_document.bucket_frontend_policy.json
}

resource "aws_s3_object" "name" {
  for_each     = fileset("./frontend/build", "**")
  bucket       = aws_s3_bucket.bucket_frontend.id
  key          = each.value
  source       = "./frontend/build/${each.value}"
  etag         = filemd5("./frontend/build/${each.value}")
  content_type = lookup(local.mime_types, regex("[^.]+$", each.value), null)
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket_frontend.id

  index_document {
    suffix = "index.html"
  }
}