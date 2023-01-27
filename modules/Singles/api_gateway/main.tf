provider "aws" {
    region = "us-east-1"
}

resource "aws_api_gateway_rest_api" "example" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "example" {
  for_each = toset(var.resource_names)
  path_part   = each.value
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.example.id
}

output "id" {
  value       = join("", aws_api_gateway_rest_api.example.*.id)
  description = "The ID of the REST API."
}

output "execution_arn" {
  value       = join("", aws_api_gateway_rest_api.example.*.execution_arn)
  description = "The Execution ARN of the REST API."
}

output "aws_api_gateway_rest_api_id" {
  value       = aws_api_gateway_rest_api.example.id
}

output "aws_api_gateway_resource_ids" {
  value = {
    for path_part, example in aws_api_gateway_resource.example : path_part => example.id
  }
}
