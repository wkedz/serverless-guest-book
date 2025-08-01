# API Gateway
lambda_payload_version = "2.0"

# Roles
iam_roles = {
  backend-lambda-role = {
    trust_relationship_principals = {
      Service = ["lambda.amazonaws.com"]
    }
    attach_policy = "backend-lambda-policy"
  }
}

# Dynamodb

dynamodb_tables = {
  comments = {
    hash_key       = "mail"
    hash_key_type  = "string"
    billing_mode   = "provisioned"
    write_capacity = 1
    read_capacity  = 1
  }
}

s3_buckets = {
  frontend-terraform-demo = {
    block_public_acls       = true
    block_public_policy     = false
    ignore_public_acls      = true
    restrict_public_buckets = false
    bucket_policy = {
      AllowPublic = {
        effect    = "Allow"
        actions   = ["s3:GetObject"]
        resources = ["arn:aws:s3:::frontend-terraform-demo/*"]
        principals = {
          #type = identifiers
          "*" = ["*"]
        }
      }
    }
  }
}

websites = {
  frontend-terraform-demo = {
    index_name = "index.html"
    website_files_directory = "./frontend/build"
  }
}