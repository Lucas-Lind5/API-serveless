# 🚀 API Serverless - Todo List

> **Projeto Cloud Native demonstrando arquitetura serverless moderna na AWS**

[![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat-square&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)

---

## 📋 Sobre o Projeto

API REST completa para gerenciamento de tarefas (To-Do List) construída com arquitetura serverless na AWS. Este projeto **paga apenas pelo uso** e **não requer gerenciamento de servidores**.

### 🎯 Stack Tecnológico

| Categoria | Tecnologia | Descrição |
|-----------|------------|-----------|
| **Compute** | AWS Lambda | Funções serverless em Python 3.11 com Boto3 |
| **Database** | Amazon DynamoDB | Banco NoSQL com modo pay-per-request |
| **API** | API Gateway | HTTP API como porta de entrada |
| **IaC** | Terraform | Infraestrutura como código |

## 🏗️ Arquitetura

```
Cliente
  │
  ▼
API Gateway (HTTP API)
  │
  ├── POST /items      → Lambda (create_item)
  ├── GET /items       → Lambda (get_items)
  ├── PUT /items/{id}  → Lambda (update_item)
  └── DELETE /items/{id} → Lambda (delete_item)
          │
          ▼
      DynamoDB (todo-items)
```

### Fluxo de Requisição

1. Cliente faz requisição HTTP para API Gateway
2. API Gateway roteia para a função Lambda apropriada
3. Lambda processa a requisição e interage com DynamoDB
4. DynamoDB armazena/recupera dados
5. Resposta retorna ao cliente via API Gateway

## 📁 Estrutura do Projeto

```
API serverless/
├── lambda/                    # Funções Lambda
│   ├── create_item.py        # POST - Criar novo item
│   ├── get_items.py          # GET - Listar/buscar itens
│   ├── update_item.py        # PUT - Atualizar item
│   └── delete_item.py        # DELETE - Deletar item
├── terraform/                 # Infraestrutura como Código
│   ├── main.tf               # Recursos principais
│   ├── variables.tf          # Variáveis configuráveis
│   ├── outputs.tf             # Outputs (URLs, ARNs, etc.)
│   └── terraform.tfvars.example
├── examples/                  # Exemplos e scripts de teste
│   ├── test_api.sh
│   └── test_api.ps1
├── requirements.txt
└── README.md
```

## 🚀 Guia de Início Rápido

### 📋 Pré-requisitos

| Ferramenta | Versão Mínima | Link |
|------------|---------------|------|
| **AWS CLI** | 2.x | [Instalar](https://aws.amazon.com/cli/) |
| **Terraform** | >= 1.0 | [Instalar](https://www.terraform.io/downloads) |
| **Python** | 3.11+ | [Instalar](https://www.python.org/downloads/) |

### ⚙️ Configuração Inicial

1. **Configure suas credenciais AWS:**
   ```bash
   aws configure
   ```
   Você precisará de:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Região padrão (ex: `us-east-1`)

2. **Verifique a instalação do Terraform:**
   ```bash
   terraform version
   ```

### 🚀 Deploy da Infraestrutura

1. **Navegue até o diretório terraform:**
   ```bash
   cd terraform
   ```

2. **Configure as variáveis (opcional):**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edite terraform.tfvars com seus valores
   ```

3. **Inicialize o Terraform:**
   ```bash
   terraform init
   ```

4. **Revise o plano de execução:**
   ```bash
   terraform plan
   ```

5. **Aplique a infraestrutura:**
   ```bash
   terraform apply
   ```
   Digite `yes` quando solicitado.

6. **Anote a URL da API:**
   Após o deploy, você verá:
   ```
   api_gateway_stage_url = "https://xxxxx.execute-api.us-east-1.amazonaws.com/v1"
   ```
   **Guarde esta URL!**

## 🧪 Testando a API

Substitua `YOUR_API_URL` pela URL obtida no output do Terraform.

### 1. Criar um Novo Item (POST)

**Requisição:**
```bash
curl -X POST https://YOUR_API_URL/v1/items \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Minha primeira tarefa",
    "description": "Descrição da tarefa",
    "completed": false
  }'
```

**Resposta (201 Created):**
```json
{
  "message": "Item criado com sucesso",
  "item": {
    "id": "item_2024-01-15T10-30-00",
    "title": "Minha primeira tarefa",
    "description": "Descrição da tarefa",
    "completed": false,
    "created_at": "2024-01-15T10:30:00",
    "updated_at": "2024-01-15T10:30:00"
  }
}
```

### 2. Listar Todos os Itens (GET)

```bash
curl https://YOUR_API_URL/v1/items
```

### 3. Buscar Item Específico (GET)

```bash
curl "https://YOUR_API_URL/v1/items?id=item_2024-01-15T10-30-00"
```

### 4. Atualizar Item (PUT)

```bash
curl -X PUT https://YOUR_API_URL/v1/items/item_2024-01-15T10-30-00 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Tarefa atualizada",
    "completed": true
  }'
```

### 5. Deletar Item (DELETE)

```bash
curl -X DELETE https://YOUR_API_URL/v1/items/item_2024-01-15T10-30-00
```

> 💡 **Dica:** Use os scripts de teste em `examples/` para testar todos os endpoints de uma vez!

## 📝 Documentação da API

### Endpoints Disponíveis

| Método | Endpoint | Descrição | Status Code |
|--------|----------|-----------|-------------|
| `POST` | `/items` | Cria um novo item | `201 Created` |
| `GET` | `/items` | Lista todos os itens | `200 OK` |
| `GET` | `/items?id={id}` | Busca um item específico | `200 OK` |
| `PUT` | `/items/{id}` | Atualiza um item existente | `200 OK` |
| `DELETE` | `/items/{id}` | Deleta um item | `200 OK` |

### Modelo de Dados

```json
{
  "id": "string",              // ID único (gerado automaticamente)
  "title": "string",           // Título da tarefa (obrigatório)
  "description": "string",     // Descrição (opcional)
  "completed": boolean,        // Status de conclusão (padrão: false)
  "created_at": "string",      // Data de criação (ISO 8601)
  "updated_at": "string"       // Data de atualização (ISO 8601)
}
```

### Códigos de Status HTTP

| Código | Significado | Quando Ocorre |
|--------|-------------|---------------|
| `200` | OK | Requisição bem-sucedida |
| `201` | Created | Item criado com sucesso |
| `400` | Bad Request | Dados inválidos |
| `404` | Not Found | Item não encontrado |
| `500` | Internal Server Error | Erro no servidor |

## ⚙️ Configuração

### Variáveis do Terraform

Crie um arquivo `terraform/terraform.tfvars`:

```hcl
aws_region   = "us-east-1"
project_name = "serverless-todo-api"
table_name   = "todo-items"
environment  = "dev"
stage_name   = "v1"
```

| Variável | Tipo | Padrão | Descrição |
|----------|------|--------|-----------|
| `aws_region` | `string` | `us-east-1` | Região AWS |
| `project_name` | `string` | `serverless-todo-api` | Nome do projeto |
| `table_name` | `string` | `todo-items` | Nome da tabela DynamoDB |
| `environment` | `string` | `dev` | Ambiente de deploy |
| `stage_name` | `string` | `v1` | Stage do API Gateway |

## 💰 Análise de Custos

Este projeto utiliza recursos serverless com modelo **pay-per-use**.

### Free Tier (Camada Gratuita)

| Serviço | Free Tier | Após Free Tier |
|---------|-----------|----------------|
| **AWS Lambda** | 1M requisições/mês<br>400,000 GB-segundos | $0.20 por 1M requisições |
| **DynamoDB** | 25 GB de armazenamento<br>25 unidades de capacidade | $0.25 por GB |
| **API Gateway** | 1M requisições/mês | $1.00 por 1M requisições |

### Estimativa de Custos

- **Uso pessoal/desenvolvimento:** $0.00 - $1.00/mês 🎉
- **Projetos pequenos/médios:** $1.00 - $5.00/mês
- **Produção com alto tráfego:** Consulte a [calculadora AWS](https://calculator.aws/)

> ⚠️ **Importante:** Sempre monitore seus custos no AWS Cost Explorer!

## 🧹 Limpeza e Remoção

Para remover todos os recursos criados:

```bash
cd terraform
terraform destroy
```

> ⚠️ **Atenção:** Este comando irá deletar permanentemente todos os recursos, incluindo dados no DynamoDB!

### Remoção Manual (Alternativa)

1. **DynamoDB** → Delete table `todo-items`
2. **Lambda** → Delete todas as funções `serverless-todo-api-*`
3. **API Gateway** → Delete API `serverless-todo-api-api`
4. **IAM** → Delete role `serverless-todo-api-lambda-role`

## 📚 Conceitos Demonstrados

### Arquitetura
- ✅ Arquitetura Serverless - Sem gerenciamento de servidores
- ✅ Microserviços - Funções Lambda independentes
- ✅ API RESTful - Padrões REST para comunicação

### DevOps & IaC
- ✅ Infrastructure as Code - Terraform
- ✅ Versionamento de Infraestrutura
- ✅ Automação de Deploy

### AWS Services
- ✅ AWS Lambda - Computação serverless
- ✅ Amazon DynamoDB - Banco NoSQL gerenciado
- ✅ API Gateway - Gerenciamento de APIs
- ✅ IAM - Gerenciamento de acesso e permissões

### Segurança & Boas Práticas
- ✅ IAM Roles e Policies - Princípio do menor privilégio
- ✅ CORS Configuration
- ✅ Environment Variables
- ✅ Error Handling
- ✅ Validação de Entrada

## 🔒 Segurança

### Medidas Implementadas

- **IAM Roles** - Permissões mínimas necessárias
- **CORS** - Configurado (ajuste para produção)
- **Validação de Entrada** - Validação de dados nas funções Lambda
- **Environment Variables** - Configurações via variáveis de ambiente
- **Logging** - CloudWatch Logs para auditoria

### Recomendações para Produção

- [ ] Implementar autenticação/autorização (AWS Cognito)
- [ ] Restringir CORS para domínios específicos
- [ ] Adicionar rate limiting no API Gateway
- [ ] Habilitar AWS WAF
- [ ] Usar AWS Secrets Manager
- [ ] Implementar VPC para isolamento
- [ ] Habilitar CloudTrail
- [ ] Configurar alertas de custo

## 🚀 Próximos Passos

### Segurança
- [ ] Adicionar autenticação com AWS Cognito
- [ ] Implementar rate limiting
- [ ] Adicionar AWS WAF
- [ ] Validação de tokens JWT

### Monitoramento
- [ ] CloudWatch Dashboards
- [ ] CloudWatch Logs Insights
- [ ] Alertas e notificações
- [ ] AWS X-Ray para tracing

### Testes
- [ ] Testes unitários (pytest)
- [ ] Testes de integração
- [ ] Linting (pylint, flake8)
- [ ] Code coverage

### CI/CD
- [ ] GitHub Actions
- [ ] Pipeline de deploy automatizado
- [ ] Testes automatizados
- [ ] Ambientes (dev, staging, prod)

### Funcionalidades
- [ ] Paginação para listagem
- [ ] Filtros e busca avançada
- [ ] Versionamento de API
- [ ] Suporte a múltiplos usuários
- [ ] Soft delete

### Performance
- [ ] Cache com ElastiCache
- [ ] Connection pooling
- [ ] Otimizar queries DynamoDB
- [ ] CDN com CloudFront


---

<div align="center">

**Desenvolvido com ❤️ usando AWS Serverless**

[![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat-square&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io/)

⭐ **Se este projeto foi útil, considere dar uma estrela!**

</div>
