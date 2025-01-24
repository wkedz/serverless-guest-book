resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_frontend_public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  # Only if we give raw name of bucket:
  # bucket = "frontend-terraform-demo"
  #   depends_on = [ 
  #     aws_s3_bucket.bucket
  #   ]
  # If we use attribute that is returned (for example id check https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#attribute-reference)
  # we then do not need dependencies
}

data "aws_iam_policy_document" "bucket_policy" {
  count = var.bucket_policy != null ? 1 : 0

  dynamic "statement" {
    for_each = var.bucket_policy

    content {
      sid     = statement.key
      effect  = statement.value.effect
      actions = statement.value.actions
      # Reference in string to resource 
      resources = statement.value.resources

      dynamic "principals" {
        for_each = statement.value.principals

        content {
          type        = principals.key
          identifiers = principals.value
        }
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  count  = var.bucket_policy != null ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy[0].json
}