resource "aws_lambda_function" "lambda" {
    filename      = "${var.func_zip_path}"
    function_name = "${var.func_name}_handler"
    role          = var.func_role_arn
    handler       = "${var.func_name}.handler"
    runtime       = var.func_runtime
    timeout = var.timeout
    layers = var.func_layers
}

module "api_method_lambda" {

  depends_on = [
    aws_lambda_function.lambda
  ]

  source   = "./../../Singles/api_method_lambda"

  rest_api_id = var.rest_id

  resource_id = var.resource_id
  
  method = var.method_type

  path = var.path

  lambda = format("%s%s",var.func_name,"_handler")

  region = var.region

  account_id = var.account_id

  authorization = var.authorization

  authorizer_id = var.authorizer_id
}