
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
