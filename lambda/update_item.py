import json
import boto3
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    """
    Lambda function para atualizar um item existente (PUT)
    """
    try:
        # Parse do body da requisição
        if isinstance(event.get('body'), str):
            body = json.loads(event['body'])
        else:
            body = event.get('body', {})
        
        # Obter ID do path parameters
        item_id = event.get('pathParameters', {}).get('id')
        
        if not item_id:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'error': 'ID do item é obrigatório'
                })
            }
        
        # Verificar se o item existe
        existing_item = table.get_item(Key={'id': item_id})
        if 'Item' not in existing_item:
            return {
                'statusCode': 404,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'error': 'Item não encontrado'
                })
            }
        
        # Preparar update expression
        update_expression = "SET updated_at = :updated_at"
        expression_attribute_values = {
            ':updated_at': datetime.now().isoformat()
        }
        
        # Adicionar campos opcionais
        if 'title' in body:
            update_expression += ", title = :title"
            expression_attribute_values[':title'] = body['title']
        
        if 'description' in body:
            update_expression += ", description = :description"
            expression_attribute_values[':description'] = body['description']
        
        if 'completed' in body:
            update_expression += ", completed = :completed"
            expression_attribute_values[':completed'] = body['completed']
        
        # Atualizar no DynamoDB
        table.update_item(
            Key={'id': item_id},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues='ALL_NEW'
        )
        
        # Buscar item atualizado
        updated_item = table.get_item(Key={'id': item_id})
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Item atualizado com sucesso',
                'item': updated_item['Item']
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': str(e)
            })
        }

