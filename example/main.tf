provider "aws" {
    region = var.region
}

// SECRETS =======================================================

resource "aws_secretsmanager_secret" "secretmasterDB" {
   name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = <<EOF
        {
            "TEMP_SECRET_NAME" : "TEMP_SECRET_VALUE"
        }
        EOF
}
 
data "aws_secretsmanager_secret" "secretmasterDB" {
  arn = aws_secretsmanager_secret.secretmasterDB.arn
}
 
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secretmasterDB.arn
}
 
resource "aws_lambda_layer_version" "secretLayer" {
  layer_name = var.layer_secret_name
  filename= var.layer_secret_zip_path
  compatible_runtimes = var.layer_secret_runtimes
}

// LAMBDA IAM ROLES =======================================================

resource "aws_iam_role" "iam_for_lambda" {
    name = "example_lambda_role"

    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
            }
        ]
    }
    EOF

    inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action   = ["secretsmanager:GetSecretValue"]
          Effect   = "Allow"
          Resource = data.aws_secretsmanager_secret.secretmasterDB.arn
        },
      ]
    })
  }
}


// API =======================================================

module "lambda_functions" {
  source = "github.com/scstonick/T4-AWS-Serverless-API?ref=latest"
  
  api_name = var.api_name

  resource_names = var.resources

  stage_name = var.stage_name

  unanimous_layers = [ aws_lambda_layer_version.secretLayer.arn ]

  user_pool_auth = 0

  functions = [
    {
      func_zip_path = "./lambda/ExampleFunction/ExampleFunction.zip"
      func_name = "ExampleFunction"
      func_runtime = "nodejs18.x"
      func_role_arn = aws_iam_role.iam_for_lambda.arn
      method_type = "GET"
      region = var.region
      account_id = var.aws_account_id
      resource_name = "ExampleResource"
      layers = [ ]
    }
  ]

}
