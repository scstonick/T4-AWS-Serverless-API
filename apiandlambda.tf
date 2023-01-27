module "api_gateway" {
  source   = "./modules/Singles/api_gateway"

  api_name = var.api_name

  resource_names = var.resource_names
}

resource "aws_api_gateway_authorizer" "auth" {
  count = var.user_pool_auth
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = module.api_gateway.id
  provider_arns = [var.cognito_user_pool_arn]
}

module "lambda_function_and_method" {
  source   = "./modules/Groupings/lambdaFuncWithGatewayMethod"
  for_each = {
    for func in var.functions:
    func.func_name => func # Perfect, since VM names also need to be unique
    # OR: index => vm (unique but not perfect, since index will change frequently)
    # OR: uuid() => vm (do NOT do this! gets recreated everytime)
  }

  func_layers = concat(each.value.layers,var.unanimous_layers)

  rest_id = module.api_gateway.aws_api_gateway_rest_api_id

  resource_id = module.api_gateway.aws_api_gateway_resource_ids[each.value.resource_name]

  func_zip_path = each.value.func_zip_path

  func_name = each.value.func_name
  
  func_runtime = each.value.func_runtime

  func_role_arn = each.value.func_role_arn
  
  method_type = each.value.method_type

  path = each.value.resource_name

  region = each.value.region

  account_id = each.value.account_id

  authorization = var.user_pool_auth == 0 ? "NONE" : "COGNITO_USER_POOLS"
  
  authorizer_id = var.user_pool_auth == 0 ? "" : aws_api_gateway_authorizer.auth[0].id

  timeout = 20
}

module "api_deployment" {
  source   = "./modules/Singles/api_gateway_deploy_stage"

  depends_on = [
    module.lambda_function_and_method
  ]

  rest_api_id = module.api_gateway.aws_api_gateway_rest_api_id

  resource_ids = [
    for aws_api_gateway_resource_ids in module.api_gateway.aws_api_gateway_resource_ids : aws_api_gateway_resource_ids
  ]
  
  method_ids = [
    for lambda_function_and_method in module.lambda_function_and_method : lambda_function_and_method.method_id
  ]

  integration_ids = [
    for lambda_function_and_method in module.lambda_function_and_method : lambda_function_and_method.integration_id
  ]
  
  stage_name = var.stage_name

}

