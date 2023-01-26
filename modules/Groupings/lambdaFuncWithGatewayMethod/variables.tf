variable "func_name" {}

variable "func_runtime" {}

variable "func_role_arn" {}

variable "func_zip_path" {}

variable "func_layers"{}

variable "method_type" {}

variable "path" {}

variable "region" {}

variable "account_id" {}

variable "rest_id" {}

variable "resource_id" {}

variable "authorization" {
  description = "NONE"
}

variable "authorizer_id" {
  default = ""
}