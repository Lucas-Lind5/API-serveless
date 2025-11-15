variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "serverless-todo-api"
}

variable "table_name" {
  description = "Nome da tabela DynamoDB"
  type        = string
  default     = "todo-items"
}

variable "environment" {
  description = "Ambiente de deploy (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "stage_name" {
  description = "Nome do stage do API Gateway"
  type        = string
  default     = "v1"
}

