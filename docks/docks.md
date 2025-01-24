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

# Loops

## Count

Loop `count` allow us to make N resoureces `count=N` . It then give us a special attirbute `count.index` so that we can use it to customize resource name. 

```tf
resource "aws_s3_bucket" "bucket" {
    count = 3
    bucket = "some-random-name-${count-index}"
}
```

This code will create 3 s3 buckets:
* some-random-name-0
* some-random-name-1
* some-random-name-2

## for_each

This is a loop that allow us to create n resources, based on the number of key-value occurenc in for_each block, for example:

```tf
resource "aws_s3_bucket" "loop" {
  for_each = {
    first_key  = "first_key_value"
    second_key = "second_key_value"
    third_key  = "third_key_value"
  }
  bucket = "loop-bucket-${each.key}-${each.value}"
}
```

This will create the following buckets:
* loop-bucket-first_key-first_key_value,
* loop-bucket-second_key-second_key_value,
* loop-bucket-thirdt_key-third_key_value,

## Refering resources created by count

If we want to target a whole resource created by `count` we need to create count insisde that resource and use `count.index` or use [INDEX]. For example:

```tf
resource "aws_s3_bucker" "some_bucket" {
  count = 3
  ...
}

resource "aws_s3_bucket_access_block" "access_blocks" {
  # USE PRECISE ONE
  bucket = aws_s3_bucket.some_bucket[INDEX].id

  # USE ALL
  count = 3
  bucket = aws_s3_bucket.some_bucket[count.index].id

}
```

## Refering resources created by for_each

Very similar as for `count`. In this case we can create same for_each block in both resources, or use index with key name.

```tf
resource "aws_s3_bucker" "some_bucket" {
  for_each = {
    key1 = "value1"
    key2 = "value2"
  }
  ...
}

resource "aws_s3_bucket_access_block" "access_blocks" {
  # USE PRECISE ONE
  bucket = aws_s3_bucket.some_bucket["key1"].id # NOTICE THAT THERE IS A BRACKET

  # USE ALL
  for_each = {
    key1 = "value1"
    key2 = "value2"
  }
  bucket = aws_s3_bucket.some_bucket["${each.key}"].id

}
```

## Creating dynamic content

Terraform allows us to create dynamic blocks. We can parametrize block for example by using for_each. We can create for example "statement" blocks. 

```tf

dynamic "statement" {
    for_each = {}
    content
}
```

We cannot put reference to resource attribute in tfvars, we need to do it inside locals.

When we are using values from for_each insisde dynamic block, we do not use standard each.key/value, but use name of dynamic block for example statement.key/value (because we use dynamic "statement")

## Conditionals

In order to create condifiton we can use "Elvis operator? :
CONDITION ? TRUE_VALUES : FALSE_VALUES

We cannot use it directly to create of not resources, but we can use combination of conditional and count loop.

```tf
resource ... {
    count = var.some_logic ? 1 : 0
...
}
```

If var.some_logic is true, Terraform will then create this resource

# Modules

## Providers

We can define out custom providers insisde modules. If not provided, module will inherited providers from root directory.

~> 4.60.0 - all version based on 4.60 will be used. for example 4.60.1, 4.60.2, 4.60.3...
~> 4.0 - all version based on 4. will be used. for example 4.40, 4.50.2, 4.60.1...

# Moving state

Sometime we would like to move a state from one resource to another. In other case, Terraform would remove it, and then recreate it. So it would be unecessary. In order to do that we need to type 

```bash
terraform state mv OLD NEW
```

This happend when we create a module with iam policy.

# Display output of main 

In order to display output of our iac, we need to define outputs.tf which contains all output variables that will be show after plan. It can be then used. This output will also be save in state file. 

# Advanced topics

## Block moved

This block is usefull when we have a resource, and we want to move its state into different resource localy. For example when we have bucket test, and we change its name to test2. Terraform would like to create test2, and remove test. 

In order to avoid it, we need to declare moved block:

```tf
moved {
  from = aws_s3_bucket.test
  to = aws_s3_bucket.test2
}
```

After apply, we can remove this block from Terraform.

## For loop

This is a special loop, that will not create resources like count, and for_each. Instead it is used for creating structures from other structures. For example 

```tf
locals {
  test_for ={
    res1 = {
      boolean = true
      str = "res1"
    }
    res2 = {
      boolean = false
      str = "res2"
    }
    res3 = {
      boolean = true
      str = "res3"
    }    
  }
}

output "test_for" {
  value = [for k, v in local.test_for : k]
}

output "test_for_map" {
  value = {for k,v in local.test_for : k => { b = v.boolean, str = v.str }}
}

output "test_for_map_2" {
  value = {for k,v in local.test_for : k => v.str }
}

output "test_for_if" {
  value = {for k,v in local.test_for : k => v.str if v.boolean }
}
```

## Target flag -target="RESOURCE_NAME"

This is a special flag that we can pass to plan (and apply if used with plan). It will select a target resources that terraform will create (even if we have many resources). This will also create any dependend resources that are needed by target resource. 

We can use multiple flags -target, at single run.

```bash
terraform plan/apply -target='RESOURCE_NAME' -target='RESOURCE_NAME'
```

## Taint command

This command is used to mark resource as damaged. It will force Terraform to replace it in the next run. In `taint` we set a special flag on resource that will change state file. In order to set resource as taint, we need to run :

```bash
terraform taint RESOURCE_NAME
```

## Replace flag

This flag is very similar to `taint` command, but it will not modify state file, but replace resource on-fly. This is usefull when we have multiple operators working on infrastructure. 


```bash
terraform plan/apply -replace='RESOURCE_NAME' -replace='RESOURCE_NAME'
```

## Paths

We can get access to paths:

```tf
output "path_module" {
  value = path.module
}

output "path_root" {
  value = path.root
}

output "path_cwd" {
  value = path.cwd
}
```

## Variables validation

We can validate user input. In order to do that we need to put `validation` block into `variable` block. For example:

```tf
variable "some_variable" {
  ...
  validation {
    error_message = "SOME ERROR MESSAGE" -> Error message must start with capitol letter, and ends with .|!|? mark
    condifiont = var.some_variable != 1 BOOL CONDITION - false -> will raise error
  }
  validation {
    WE CAN HAVE MULTIPLE VALIDATION BLOCKS
  }
}
```

Block `validation` can only refer to the variable block, that it is used. It canno refer to other variable. In order to have dependencies we need to make precondition block in `resource`

## Import command

This command is used for importing handmade infrastructure components into our local state. It will allows to manage it by using Terraform. 

## Lifecycle

We can manipulate lifecycle of the resource by using `lifecycle` block in the `resource`. For example 

```tf

resource "aws_s3_bucket" "lifecycle" {
  ...

  lifecycle {
    prevent_destroy = true       -> this will prevent from destroying this resource. if we mark it with `taint` we will get an error.
                                    this flag will not be stored in stat file, so if we remove this block, we will be able to remove this resource
    create_before_destroy = true -> this flag will tell Terraform to first create resource, before removing it, this can increase HA, because we will
                                    have resource created first.
    ignore_changes = [ attribute_of_resource ] -> this flag will tell Terraform to ignore changes of given attribute.

    replace_triggered_by = [ other_resource_namr ] -> this will force changes on this resource, because we  made changes to other_resource_namr

    precondition {
      Checks condition before applying
      error_message = "THIS CAN BE ANY PARTICULAR MESSAGE (NOT LIKE IN VALIDATION)."
      condition = we can refer here to any particular attribute from other resources, but we cannot refer to Self. Refer to the attribute 
                  that are know at planing, because those resources are known, for example for s3 bucket attribute is known, but id will be
                  known after apply.
    }

    postcondition {
      Checks condition after applying, in this block, we can refer to self
      error_message = "THIS CAN BE ANY PARTICULAR MESSAGE (NOT LIKE IN VALIDATION)."
      condition = self.attribute = some_logic
    }
  }
}
```

## Multiregion

We can select region in which we will deploy our resources. In order to do that, we need to declare another `provider` block, and give it an `alias` attribute.

```tf

provider "aws" {
  region = "eu-west-3"
  alias = "paris"
}
```

Now, we can use it in any resource/module block. Those blocks has an optional attribute `provider`. For example 

```tf
module {


  providers = {
    aws = aws.paris
  }
}
```

Now, this module will be created in aws.paris region.

## Provisioners local-exec, file and remote-exec

We can apply custom scripts on created resouce by using `provisioner` block. We have the following block:
* local-exec - this will execute commands locally,
* file - this will upload given file to target resource which is defined by `connection` block,
* remote-exec - this will execute custom commands on target resource which is defined by `connection` block, we can use `self` here.

Providers block do not change state file of Terraform, so in order to perform it, we need to taint existing resource, or create new one with provisioner block. 

```tf
provisioner "local-exec" {
  command = "echo 'Some custom command.'"
}

connection {
  type = 
  host =
  user = 
  private_key = file(path to id_rsa)
}

provisioner "file" {
  source = path_to_file
  destination = where to put file
}

provisioner "remote-exec" {
  inline = ["echo 'some other command executed remotly."]
}
```

## Null_resource and null_data_source

Resource `null_resource` is a special type of resource, that is provided by null provider. It allow us to create dangling resource, that can be use to perform some action, but not to create a resource, on the cloud (thats why it is called null). This resource block has a special attribure `triggers` that is a map, that accepts any particula values, that if change will force teraform to recreate null_resource. For example:

```tf
resource "null_resource" "null" {
  triggers = {
    change = some_value
  }

  provisioner "local-exec" {
    command = SOME_COMMAND
  }
}
```

This resource will perform local-exec.command each time if `triggers` change. The main benefit of this, is that stat of this resource is store in state file. So we follow any changes to `triggers.change` value.

Another usefull block is `null_data_source`. This data clock allows us to get any articula input, and use it as output. For example:

```tf
data "null_data_source" "null" {
  inputs = {
    file = file("some_file.txt")
  }
}

output "null_data_source" {
  value = data.null_data_source.null.outputs.file
}
```

Now we can put any inputs to `data.null_data_source.null` and print it to `null_data_source.value`

Since Terraform 1.4  there is a `terraform_data` that has same functionalities as `null_resource` and `null_data_source`