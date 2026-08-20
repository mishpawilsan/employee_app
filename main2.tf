terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Zip Python Code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/employee_handler.py"
  output_path = "${path.module}/employee_handler.zip"
}

# IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "employee_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

# Attach Basic Execution Policy
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Resource
resource "aws_lambda_function" "employee_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "employee_directory_api"
  role             = aws_iam_role.lambda_role.arn
  handler          = "employee_handler.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}