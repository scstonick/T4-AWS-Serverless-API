variable "aws_account_id" {
    
}

variable "secret_name" {
    
}

variable "layer_secret_name" {
    default = "ExampleSecretLayer"
}

variable "layer_secret_runtimes" {
    default = ["nodejs18.x"]
}

variable "layer_secret_zip_path" {
    //default = "./lambda/layerSecrets/layerSecrets.zip"
}

variable "resources" {
    default = [ "ExampleResource" ]
}

variable "stage_name" {
    default = "init"
}

variable "api_name" {
    default = "Example_Gateway"
}

variable "region" {
    default = "us-east-1"
}

variable "cognito_user_pool_arn" {
    
}