
# 🚀 API Serverless - Todo List

**Projeto Cloud Native demonstrando arquitetura serverless moderna na AWS**

[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Serverless](https://img.shields.io/badge/Serverless-FD5750?style=for-the-badge&logo=serverless&logoColor=white)](https://www.serverless.com/)

[![License](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)
[![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-FF9900?style=flat-square&logo=aws-lambda&logoColor=white)](https://aws.amazon.com/lambda/)
[![DynamoDB](https://img.shields.io/badge/AWS-DynamoDB-4053D6?style=flat-square&logo=amazon-dynamodb&logoColor=white)](https://aws.amazon.com/dynamodb/)

</div>

---

## 📋 Sobre o Projeto

Este é um projeto **Cloud Native** que demonstra uma arquitetura serverless moderna na AWS. Uma API REST completa para gerenciamento de tarefas (To-Do List) que **paga apenas pelo uso** e **não requer gerenciamento de servidores**.

### 🎯 Tecnologias Utilizadas

| Categoria | Tecnologia | Descrição |
|-----------|------------|-----------|
| 🖥️ **Compute** | AWS Lambda | Funções serverless em Python 3.11 com Boto3 |
| 💾 **Database** | Amazon DynamoDB | Banco NoSQL com modo pay-per-request |
| 🌐 **API** | API Gateway | HTTP API como porta de entrada |
| 🏗️ **IaC** | Terraform | Infraestrutura como código |

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│                  🌐 API Gateway (HTTP API)              │
└───────────────────────┬─────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
   ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
   │  POST   │    │   GET   │    │   PUT   │
   │ /items  │    │ /items  │    │/items/id│
   └────┬────┘    └────┬────┘    └────┬────┘
        │              │               │
   ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
   │ CREATE  │    │   GET   │    │  UPDATE │
   │  ITEM   │    │  ITEMS  │    │   ITEM  │
   └────┬────┘    └────┬────┘    └────┬────┘
        │              │               │
        └──────────────┼───────────────┘
                       │
              ┌────────▼────────┐
              │   🐍 AWS Lambda │
              │  (Python 3.11)  │
              └────────┬────────┘
                       │
              ┌────────▼────────┐
              │  💾 DynamoDB     │
              │  (NoSQL Table)   │
              └──────────────────┘
```

### 📊 Fluxo de Requisição

1. **Cliente** → Faz requisição HTTP para API Gateway
2. **API Gateway** → Roteia para a função Lambda apropriada
3. **Lambda** → Processa a requisição e interage com DynamoDB
4. **DynamoDB** → Armazena/recupera dados
5. **Resposta** → Retorna ao cliente via API Gateway

## 📁 Estrutura do Projeto

```
API serverless/
│
├── 📂 lambda/                    # Funções Lambda
│   ├── create_item.py           # ✨ POST - Criar novo item
│   ├── get_items.py             # 📖 GET - Listar/buscar itens
│   ├── update_item.py           # 🔄 PUT - Atualizar item
│   └── delete_item.py           # 🗑️ DELETE - Deletar item
│
├── 📂 terraform/                 # Infraestrutura como Código
│   ├── main.tf                  # 🏗️ Recursos principais
│   ├── variables.tf             # ⚙️ Variáveis configuráveis
│   ├── outputs.tf               # 📤 Outputs (URLs, ARNs, etc.)
│   ├── terraform.tfvars.example # 📝 Exemplo de configuração
│   └── .gitignore              # 🚫 Arquivos ignorados
│
├── 📂 examples/                  # Exemplos e scripts de teste
│   ├── test_api.sh             # 🧪 Script Bash para testes
│   └── test_api.ps1            # 🧪 Script PowerShell para testes
│
├── requirements.txt              # 📦 Dependências Python
├── .gitignore                   # 🚫 Arquivos ignorados
└── README.md                    # 📚 Este arquivo
```

## 🚀 Guia de Início Rápido

### 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

| Ferramenta | Versão Mínima | Como Instalar |
|------------|---------------|---------------|
| **AWS CLI** | 2.x | [Instalar AWS CLI](https://aws.amazon.com/cli/) |
| **Terraform** | >= 1.0 | [Instalar Terraform](https://www.terraform.io/downloads) |
| **Python** | 3.11+ | [Instalar Python](https://www.python.org/downloads/) |

#### ⚙️ Configuração Inicial

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

Siga estes passos para fazer o deploy completo da aplicação:

#### 1️⃣ Clone e Navegue até o Projeto
```bash
cd "API serverless/terraform"
```

#### 2️⃣ Configure as Variáveis (Opcional)
Copie o arquivo de exemplo e ajuste conforme necessário:
```bash
cp terraform.tfvars.example terraform.tfvars
# Edite terraform.tfvars com seus valores
```

#### 3️⃣ Inicialize o Terraform
```bash
terraform init
```
Este comando baixa os providers necessários (AWS).

#### 4️⃣ Revise o Plano de Execução
```bash
terraform plan
```
Revise os recursos que serão criados antes de aplicar.

#### 5️⃣ Aplique a Infraestrutura
```bash
terraform apply
```
Digite `yes` quando solicitado para confirmar.

#### 6️⃣ Anote a URL da API
Após o deploy bem-sucedido, você verá algo como:
```
✅ api_gateway_stage_url = "https://xxxxx.execute-api.us-east-1.amazonaws.com/v1"
```
**Guarde esta URL!** Você precisará dela para testar a API.

### 🧪 Testando a API

Substitua `YOUR_API_URL` pela URL obtida no output do Terraform.

#### 1️⃣ Criar um Novo Item (POST)

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

#### 2️⃣ Listar Todos os Itens (GET)

**Requisição:**
```bash
curl https://YOUR_API_URL/v1/items
```

**Resposta (200 OK):**
```json
{
  "count": 2,
  "items": [
    {
      "id": "item_2024-01-15T10-30-00",
      "title": "Minha primeira tarefa",
      "description": "Descrição da tarefa",
      "completed": false,
      "created_at": "2024-01-15T10:30:00",
      "updated_at": "2024-01-15T10:30:00"
    }
  ]
}
```

#### 3️⃣ Buscar Item Específico (GET)

**Requisição:**
```bash
curl "https://YOUR_API_URL/v1/items?id=item_2024-01-15T10-30-00"
```

**Resposta (200 OK):**
```json
{
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

#### 4️⃣ Atualizar Item (PUT)

**Requisição:**
```bash
curl -X PUT https://YOUR_API_URL/v1/items/item_2024-01-15T10-30-00 \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Tarefa atualizada",
    "completed": true
  }'
```

**Resposta (200 OK):**
```json
{
  "message": "Item atualizado com sucesso",
  "item": {
    "id": "item_2024-01-15T10-30-00",
    "title": "Tarefa atualizada",
    "description": "Descrição da tarefa",
    "completed": true,
    "created_at": "2024-01-15T10:30:00",
    "updated_at": "2024-01-15T10:35:00"
  }
}
```

#### 5️⃣ Deletar Item (DELETE)

**Requisição:**
```bash
curl -X DELETE https://YOUR_API_URL/v1/items/item_2024-01-15T10-30-00
```

**Resposta (200 OK):**
```json
{
  "message": "Item deletado com sucesso",
  "id": "item_2024-01-15T10-30-00"
}
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

### 📋 Modelo de Dados

#### Item (Todo)
```json
{
  "id": "string",              // ID único do item (gerado automaticamente)
  "title": "string",           // Título da tarefa (obrigatório)
  "description": "string",     // Descrição da tarefa (opcional)
  "completed": boolean,        // Status de conclusão (padrão: false)
  "created_at": "string",      // Data de criação (ISO 8601)
  "updated_at": "string"       // Data de última atualização (ISO 8601)
}
```

### 🔍 Códigos de Status HTTP

| Código | Significado | Quando Ocorre |
|--------|-------------|---------------|
| `200` | OK | Requisição bem-sucedida |
| `201` | Created | Item criado com sucesso |
| `400` | Bad Request | Dados inválidos na requisição |
| `404` | Not Found | Item não encontrado |
| `500` | Internal Server Error | Erro no servidor |

## ⚙️ Configuração

### 🔧 Variáveis do Terraform

O projeto utiliza variáveis configuráveis para facilitar a customização. Você pode:

1. **Editar diretamente** `terraform/variables.tf`
2. **Criar um arquivo** `terraform/terraform.tfvars` (recomendado)
3. **Usar variáveis de ambiente** do Terraform

#### Exemplo de `terraform.tfvars`:

```hcl
# Região AWS onde os recursos serão criados
aws_region = "us-east-1"

# Nome do projeto (usado como prefixo para recursos)
project_name = "serverless-todo-api"

# Nome da tabela DynamoDB
table_name = "todo-items"

# Ambiente (dev, staging, prod)
environment = "dev"

# Nome do stage do API Gateway
stage_name = "v1"
```

#### Variáveis Disponíveis:

| Variável | Tipo | Padrão | Descrição |
|----------|------|--------|-----------|
| `aws_region` | `string` | `us-east-1` | Região AWS |
| `project_name` | `string` | `serverless-todo-api` | Nome do projeto |
| `table_name` | `string` | `todo-items` | Nome da tabela DynamoDB |
| `environment` | `string` | `dev` | Ambiente de deploy |
| `stage_name` | `string` | `v1` | Stage do API Gateway |

## 💰 Análise de Custos

Este projeto utiliza recursos serverless com modelo **pay-per-use**, o que significa que você paga apenas pelo que usar!

### 📊 Free Tier (Camada Gratuita)

| Serviço | Free Tier | Após Free Tier |
|---------|-----------|----------------|
| **AWS Lambda** | 1M requisições/mês<br>400,000 GB-segundos | $0.20 por 1M requisições<br>$0.0000166667 por GB-segundo |
| **DynamoDB** | 25 GB de armazenamento<br>25 unidades de capacidade de escrita<br>25 unidades de capacidade de leitura | $0.25 por GB<br>$1.25 por milhão de escritas<br>$0.25 por milhão de leituras |
| **API Gateway** | 1M requisições/mês | $1.00 por 1M requisições |

### 💡 Estimativa de Custos

Para uso pessoal/desenvolvimento com tráfego baixo:
- **Custo mensal estimado: $0.00 - $1.00** 🎉
- Para projetos pequenos/médios: **$1.00 - $5.00/mês**
- Para produção com alto tráfego: Consulte a [calculadora AWS](https://calculator.aws/)

> ⚠️ **Importante:** Sempre monitore seus custos no AWS Cost Explorer!

## 🧹 Limpeza e Remoção

Para remover todos os recursos criados na AWS e evitar custos:

```bash
cd terraform
terraform destroy
```

> ⚠️ **Atenção:** Este comando irá **deletar permanentemente** todos os recursos criados, incluindo:
> - Tabela DynamoDB e todos os dados
> - Funções Lambda
> - API Gateway
> - IAM Roles e Policies
>
> Certifique-se de fazer backup dos dados importantes antes de executar!

### 🗑️ Remoção Manual (Alternativa)

Se preferir remover recursos manualmente via AWS Console:
1. **DynamoDB** → Delete table `todo-items`
2. **Lambda** → Delete todas as funções `serverless-todo-api-*`
3. **API Gateway** → Delete API `serverless-todo-api-api`
4. **IAM** → Delete role `serverless-todo-api-lambda-role`

## 📚 Conceitos e Tecnologias Demonstradas

Este projeto demonstra os seguintes conceitos de Cloud Native e Serverless:

### 🏗️ Arquitetura
- ✅ **Arquitetura Serverless** - Sem gerenciamento de servidores
- ✅ **Microserviços** - Funções Lambda independentes
- ✅ **API RESTful** - Padrões REST para comunicação

### 🛠️ DevOps & IaC
- ✅ **Infrastructure as Code** - Terraform para gerenciar infraestrutura
- ✅ **Versionamento de Infraestrutura** - Controle de versão da infra
- ✅ **Automação** - Deploy automatizado

### ☁️ AWS Services
- ✅ **AWS Lambda** - Computação serverless
- ✅ **Amazon DynamoDB** - Banco NoSQL gerenciado
- ✅ **API Gateway** - Gerenciamento de APIs
- ✅ **IAM** - Gerenciamento de acesso e permissões

### 🔒 Segurança & Boas Práticas
- ✅ **IAM Roles e Policies** - Princípio do menor privilégio
- ✅ **CORS Configuration** - Controle de acesso cross-origin
- ✅ **Environment Variables** - Configuração segura
- ✅ **Error Handling** - Tratamento robusto de erros
- ✅ **Validação de Entrada** - Validação de dados

## 🔒 Segurança

### ✅ Medidas de Segurança Implementadas

- **🔐 IAM Roles** - Permissões mínimas necessárias (princípio do menor privilégio)
- **🌐 CORS** - Configurado para permitir requisições cross-origin (ajuste para produção)
- **✅ Validação de Entrada** - Validação de dados nas funções Lambda
- **🔑 Environment Variables** - Configurações sensíveis via variáveis de ambiente
- **📝 Logging** - CloudWatch Logs para auditoria

### ⚠️ Recomendações para Produção

- [ ] Implementar autenticação/autorização (AWS Cognito)
- [ ] Restringir CORS para domínios específicos
- [ ] Adicionar rate limiting no API Gateway
- [ ] Habilitar AWS WAF para proteção adicional
- [ ] Usar AWS Secrets Manager para credenciais
- [ ] Implementar VPC para isolamento de rede
- [ ] Habilitar CloudTrail para auditoria
- [ ] Configurar alertas de custo no AWS Budgets

## 🚀 Próximos Passos e Melhorias

### 🔐 Segurança
- [ ] Adicionar autenticação/autorização com AWS Cognito
- [ ] Implementar rate limiting no API Gateway
- [ ] Adicionar AWS WAF para proteção adicional
- [ ] Implementar validação de tokens JWT

### 📊 Monitoramento e Observabilidade
- [ ] Configurar CloudWatch Dashboards
- [ ] Adicionar CloudWatch Logs Insights queries
- [ ] Implementar alertas e notificações
- [ ] Adicionar AWS X-Ray para tracing distribuído

### 🧪 Testes e Qualidade
- [ ] Adicionar testes unitários (pytest)
- [ ] Implementar testes de integração
- [ ] Configurar linting (pylint, flake8)
- [ ] Adicionar code coverage

### 🔄 CI/CD
- [ ] Configurar GitHub Actions para CI/CD
- [ ] Implementar pipeline de deploy automatizado
- [ ] Adicionar testes automatizados no pipeline
- [ ] Configurar ambientes (dev, staging, prod)

### 🎯 Funcionalidades
- [ ] Implementar paginação para listagem de itens
- [ ] Adicionar filtros e busca avançada
- [ ] Implementar versionamento de API
- [ ] Adicionar suporte a múltiplos usuários
- [ ] Implementar soft delete (marcar como deletado)

### 📈 Performance
- [ ] Adicionar cache com ElastiCache
- [ ] Implementar connection pooling
- [ ] Otimizar queries DynamoDB
- [ ] Adicionar CDN com CloudFront

---



#   A P I - s e r v e l e s s 
 
 
