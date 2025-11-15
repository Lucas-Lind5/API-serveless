#!/bin/bash

# Script de exemplo para testar a API Serverless
# Substitua YOUR_API_URL pela URL do seu API Gateway

API_URL="YOUR_API_URL/v1"

echo "🚀 Testando API Serverless - Todo List"
echo "========================================"
echo ""

# 1. Criar um novo item
echo "1️⃣ Criando novo item..."
RESPONSE=$(curl -s -X POST "$API_URL/items" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Minha primeira tarefa",
    "description": "Esta é uma tarefa de exemplo",
    "completed": false
  }')

echo "$RESPONSE" | python -m json.tool
ITEM_ID=$(echo "$RESPONSE" | python -c "import sys, json; print(json.load(sys.stdin)['item']['id'])")
echo ""
echo "✅ Item criado com ID: $ITEM_ID"
echo ""

# 2. Listar todos os itens
echo "2️⃣ Listando todos os itens..."
curl -s "$API_URL/items" | python -m json.tool
echo ""

# 3. Buscar item específico
echo "3️⃣ Buscando item específico..."
curl -s "$API_URL/items?id=$ITEM_ID" | python -m json.tool
echo ""

# 4. Atualizar item
echo "4️⃣ Atualizando item..."
curl -s -X PUT "$API_URL/items/$ITEM_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Tarefa atualizada",
    "completed": true
  }' | python -m json.tool
echo ""

# 5. Deletar item
echo "5️⃣ Deletando item..."
curl -s -X DELETE "$API_URL/items/$ITEM_ID" | python -m json.tool
echo ""

echo "✅ Testes concluídos!"

