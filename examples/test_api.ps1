# Script PowerShell de exemplo para testar a API Serverless
# Substitua YOUR_API_URL pela URL do seu API Gateway

$API_URL = "YOUR_API_URL/v1"

Write-Host "🚀 Testando API Serverless - Todo List" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Criar um novo item
Write-Host "1️⃣ Criando novo item..." -ForegroundColor Yellow
$body = @{
    title = "Minha primeira tarefa"
    description = "Esta é uma tarefa de exemplo"
    completed = $false
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "$API_URL/items" -Method Post -Body $body -ContentType "application/json"
$response | ConvertTo-Json -Depth 10
$itemId = $response.item.id
Write-Host ""
Write-Host "✅ Item criado com ID: $itemId" -ForegroundColor Green
Write-Host ""

# 2. Listar todos os itens
Write-Host "2️⃣ Listando todos os itens..." -ForegroundColor Yellow
$items = Invoke-RestMethod -Uri "$API_URL/items" -Method Get
$items | ConvertTo-Json -Depth 10
Write-Host ""

# 3. Buscar item específico
Write-Host "3️⃣ Buscando item específico..." -ForegroundColor Yellow
$item = Invoke-RestMethod -Uri "$API_URL/items?id=$itemId" -Method Get
$item | ConvertTo-Json -Depth 10
Write-Host ""

# 4. Atualizar item
Write-Host "4️⃣ Atualizando item..." -ForegroundColor Yellow
$updateBody = @{
    title = "Tarefa atualizada"
    completed = $true
} | ConvertTo-Json

$updated = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method Put -Body $updateBody -ContentType "application/json"
$updated | ConvertTo-Json -Depth 10
Write-Host ""

# 5. Deletar item
Write-Host "5️⃣ Deletando item..." -ForegroundColor Yellow
$deleted = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method Delete
$deleted | ConvertTo-Json -Depth 10
Write-Host ""

Write-Host "✅ Testes concluídos!" -ForegroundColor Green

