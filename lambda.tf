module "iam_policy" {
  source = "./modules/iam_policy"

  for_each = local.iam_polices

  name       = each.key
  statements = each.value
}

module "iam_roles" {
  source = "./modules/iam_role"

  for_each = var.iam_roles

  name                          = each.key
  trust_relationship_principals = each.value.trust_relationship_principals
  policy_arn                    = module.iam_policy[each.value.attach_policy].policy_arn
}

module "lambda" {
  source = "./modules/lambda"

  for_each = local.lambda_functions

  function_name         = each.key
  code_dir              = each.value.code_dir
  execution_role_arn    = module.iam_roles[each.value.execution_role].arn
  handler_name          = each.value.handler_name
  runtime_env           = each.value.runtime_env
  environment_variables = each.value.environment_variables
  permissions           = each.value.permissions
}