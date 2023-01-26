
variable "api_name" {
  # default = "examplegateway"
}

variable "resource_names" {
  # default = ["exampleresource1", "exampleresource2"]
}

variable "stage_name" {
  # default = "init"
}

variable "unanimous_layers" {
  
}

variable "user_pool_auth" {
  type = number
  default = 0
}

variable "cognito_user_pool_arn" {
  default = ""
}

variable "functions" {
  type = list(object({
        func_zip_path = string
        func_name = string
        func_runtime = string
        func_role_arn = string
        method_type = string
        region = string
        account_id = string
        resource_name = string
        layers = list(string)
  }))


  # default = [
  #   {
  #     func_zip_path = "./../../../lambda/loginfunction/loginfunction.zip"
  #     func_name = "loginfunctionn"
  #     func_runtime = "nodejs18.x"
  #     func_role_name = "lambda_role_onee"
  #     method_type = "POST"
  #     path = "/JWTResource"
  #     region = "us-east-2"
  #     account_id = "234810685479"
  #     resource_name = "exampleresource1"
  #     layers = []
  #     authorization = "NONE"
  #     authorizer_id = ""
  #   }
  # ]
}