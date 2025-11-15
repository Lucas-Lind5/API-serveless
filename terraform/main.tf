terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# DynamoDB Table
resource "aws_dynamodb_table" "todo_table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST" # Serverless - paga apenas pelo uso
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "Todo List Table"
    Environment = var.environment
    Project     = "Serverless API"
  }
}

# IAM Role para Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy para Lambda acessar DynamoDB
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "${var.project_name}-lambda-dynamodb-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.todo_table.arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Lambda Layer para boto3 (opcional, já que boto3 vem no runtime Python)
# Vamos usar o runtime Python padrão que já inclui boto3

# Lambda Function - Create Item
data "archive_file" "create_item_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/create_item.py"
  output_path = "${path.module}/lambda_create_item.zip"
}

resource "aws_lambda_function" "create_item" {
  filename         = data.archive_file.create_item_zip.output_path
  function_name    = "${var.project_name}-create-item"
  role             = aws_iam_role.lambda_role.arn
  handler          = "create_item.lambda_handler"
  source_code_hash = data.archive_file.create_item_zip.output_base64sha256
  runtime          = "python3.11"
  timeout          = 30

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todo_table.name
    }
  }

  tags = {
    Name = "${var.project_name}-create-item"
    Environment = var.environment
  }
}

# Lambda Function - Get Items
data "archive_file" "get_items_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/get_items.py"
  output_path = "${path.module}/lambda_get_items.zip"
}

resource "aws_lambda_function" "get_items" {
  filename         = data.archive_file.get_items_zip.output_path
  function_name    = "${var.project_name}-get-items"
  role             = aws_iam_role.lambda_role.arn
  handler          = "get_items.lambda_handler"
  source_code_hash = data.archive_file.get_items_zip.output_base64sha256
  runtime          = "python3.11"
  timeout          = 30

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todo_table.name
    }
  }

  tags = {
    Name = "${var.project_name}-get-items"
    Environment = var.environment
  }
}

# Lambda Function - Update Item
data "archive_file" "update_item_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/update_item.py"
  output_path = "${path.module}/lambda_update_item.zip"
}

resource "aws_lambda_function" "update_item" {
  filename         = data.archive_file.update_item_zip.output_path
  function_name    = "${var.project_name}-update-item"
  role             = aws_iam_role.lambda_role.arn
  handler          = "update_item.lambda_handler"
  source_code_hash = data.archive_file.update_item_zip.output_base64sha256
  runtime          = "python3.11"
  timeout          = 30

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todo_table.name
    }
  }

  tags = {
    Name = "${var.project_name}-update-item"
    Environment = var.environment
  }
}

# Lambda Function - Delete Item
data "archive_file" "delete_item_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda/delete_item.py"
  output_path = "${path.module}/lambda_delete_item.zip"
}

resource "aws_lambda_function" "delete_item" {
  filename         = data.archive_file.delete_item_zip.output_path
  function_name    = "${var.project_name}-delete-item"
  role             = aws_iam_role.lambda_role.arn
  handler          = "delete_item.lambda_handler"
  source_code_hash = data.archive_file.delete_item_zip.output_base64sha256
  runtime          = "python3.11"
  timeout          = 30

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.todo_table.name
    }
  }

  tags = {
    Name = "${var.project_name}-delete-item"
    Environment = var.environment
  }
}

# API Gateway REST API
resource "aws_apigatewayv2_api" "api" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
  description   = "API Serverless para Todo List"
  
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key"]
  }

  tags = {
    Name        = "${var.project_name}-api"
    Environment = var.environment
  }
}

# API Gateway Integration - Create Item
resource "aws_apigatewayv2_integration" "create_item_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.create_item.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration - Get Items
resource "aws_apigatewayv2_integration" "get_items_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.get_items.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration - Update Item
resource "aws_apigatewayv2_integration" "update_item_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.update_item.invoke_arn
  integration_method = "POST"
}

# API Gateway Integration - Delete Item
resource "aws_apigatewayv2_integration" "delete_item_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.delete_item.invoke_arn
  integration_method = "POST"
}

# API Gateway Route - POST /items
resource "aws_apigatewayv2_route" "create_item_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.create_item_integration.id}"
}

# API Gateway Route - GET /items
resource "aws_apigatewayv2_route" "get_items_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.get_items_integration.id}"
}

# API Gateway Route - GET /items/{id}
resource "aws_apigatewayv2_route" "get_item_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.get_items_integration.id}"
}

# API Gateway Route - PUT /items/{id}
resource "aws_apigatewayv2_route" "update_item_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "PUT /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.update_item_integration.id}"
}

# API Gateway Route - DELETE /items/{id}
resource "aws_apigatewayv2_route" "delete_item_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_item_integration.id}"
}

# API Gateway Stage
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = var.stage_name
  auto_deploy = true
}

# Lambda Permissions - Create Item
resource "aws_lambda_permission" "create_item_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# Lambda Permissions - Get Items
resource "aws_lambda_permission" "get_items_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_items.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# Lambda Permissions - Update Item
resource "aws_lambda_permission" "update_item_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

# Lambda Permissions - Delete Item
resource "aws_lambda_permission" "delete_item_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_item.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

