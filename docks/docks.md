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

# Backend in S3

Deploying tfstate file to S3 allows us to share state file with fellow devs/ops. Another advantage is that we can set lock on it, so that only one person can modify it at the time.

If we already have local state, we need to run `terraform init`. Terraform will then migrate local state into remote s3e bucket. 

It is good practice to do `terraform refresh` state (`refresh` is deprecated use terraform apply -refresh-only)

Refresh will only `tfstate` file according to actual infrastructure, but IT DOES NOT UPDATE tf files. It need to be done manually.

## Locking remote state

Locking is required, because it prevents from modifing resources by multiple ops at the same time. We can achieve locking by creating special table LockID in dynamoDB. 

For more reference check https://developer.hashicorp.com/terraform/language/backend/s3

# Variables

In order to customize stack, we can use variables block 
```tf
variable "NAME" {

}
```

If no name is provided Terraform will ask for one. We can either set it by providing -var="NAME=VALUE" during apply/plan

## Variable types

Any
Bool
Number
String
List
Set
Map
Object
tuple

## Set variables by file

It is possile to define variables values by using *.tfvars . In order to use it, you need to pass it by -var-file=PATH-TO-TFVARS.tfvars

We can load it automaticlly, we just need to change name from PATH-TO-TFVARS.tfvars to PATH-TO-TFVARS.auto.tfvars Terraform will then load this file automatically, without a need of passing it -var-file. This is for the situation when name of this file is different than terraform.tfvars.

This file name - terraform.tfvars, will work automatically.