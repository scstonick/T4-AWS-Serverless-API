
resource "aws_api_gateway_deployment" "example" {
  rest_api_id = var.rest_api_id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode(concat(
      concat(
        var.resource_ids,
        var.integration_ids
      ),
      var.method_ids
    )))
    # we want to redploy anytime there are changes with the resources, methods, or integrations.
    # thats why theres these ugly concats
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = var.rest_api_id
  stage_name    = var.stage_name
}
