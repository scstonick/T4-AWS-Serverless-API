
variable "api_name" {
  type = string
  description = "This will be the name of the AWS API Gateway"
  # default = "examplegateway"
}

variable "resource_names" {
  type = list(string)
  description = "This is an array of resource names you want to make in the AWS API Gateway"
  # default = ["exampleresource1", "exampleresource2"]
}

variable "stage_name" {
  type = string
  description = "This will be the name of the gateway's stage"
  # default = "init"
}

variable "unanimous_layers" {
  type = list(string)
  description = "This is an array of ARNs of lambda layer that you want to be integrated all lambda functions this module creates"
  
}

variable "user_pool_auth" {
  type = number
  description = "This is a sort of boolean for integrating auth with the API being created. Set to 0 to not use auth and set to 1 in order to use auth. If using authenticaiton you must also provide a cognitio user pool ARN in the variable 'cognito_user_pool_arn'."
  default = 0
}

variable "cognito_user_pool_arn" {
  type = string
  description = "If 'user_pool_auth' is set to 1 then this variable must be set to an AWS Cognito user pool's ARN. If not using auth then ignore this."
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
  description = "this variable takes a list of objects. Each object will generate a lambda function and a method in the API Gateway that integrates that lambda function"
}