output "api_gateway_url" {
  description = "URL do API Gateway"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "api_gateway_stage_url" {
  description = "URL completa do API Gateway com stage"
  value       = "${aws_apigatewayv2_api.api.api_endpoint}/${aws_apigatewayv2_stage.api_stage.name}"
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  value       = aws_dynamodb_table.todo_table.name
}

output "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB"
  value       = aws_dynamodb_table.todo_table.arn
}

output "lambda_functions" {
  description = "Nomes das funções Lambda criadas"
  value = {
    create_item = aws_lambda_function.create_item.function_name
    get_items   = aws_lambda_function.get_items.function_name
    update_item = aws_lambda_function.update_item.function_name
    delete_item = aws_lambda_function.delete_item.function_name
  }
}

