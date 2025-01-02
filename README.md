# serverless-guest-book
Simple serverless app storing user email and comments.

# Set credentials 

Create file .env with :

```bash
export AWS_ACCESS_KEY_ID="YOUR_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
```

And source it:

```bash
source .env
```

# Show dependencies between services 

Use `terraform graph`. It will show dependencies between services. 

# Parallel creation of resources

By default, Terraform can create up to 10 resoureces one of the time. So if we want to modify some bucket configuration, we need be sure, that it is created first. 

To point that resources/modules/datasource depending on each other, we can use in resouce block clausule `depends_on`.

We can now see this dependencies by running `terraform graph`.

If we use attribute that is returned (for example id check https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#attribute-reference)
we then do not need dependencies.

# Inject reference of resource into string 

If we want to use attribute from resource we need to use ${} inside string. For example:

```bash
resources = ["${aws_s3_bucket.bucket_frontend.arn}/*"]
```