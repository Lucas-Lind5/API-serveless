import json
import boto3
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    """
    Lambda function para listar todos os itens ou buscar um item específico (GET)
    """
    try:
        # Verificar se há um ID na query string (buscar item específico)
        item_id = None
        if event.get('queryStringParameters') and event['queryStringParameters'].get('id'):
            item_id = event['queryStringParameters']['id']
        
        if item_id:
            # Buscar item específico
            response = table.get_item(
                Key={'id': item_id}
            )
            
            if 'Item' not in response:
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
            
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'item': response['Item']
                })
            }
        else:
            # Listar todos os itens
            response = table.scan()
            items = response.get('Items', [])
            
            # Ordenar por created_at (mais recentes primeiro)
            items.sort(key=lambda x: x.get('created_at', ''), reverse=True)
            
            return {
                'statusCode': 200,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'count': len(items),
                    'items': items
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

