provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "tf-state-rc-napi"
    region = "eu-west-2"
    key = "napi.tfstate"
  }
}

resource "aws_apigatewayv2_api" "api-gateway" {
  name          = "notes-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "gateway-integration" {
  api_id           = aws_apigatewayv2_api.api-gateway.id
  integration_type = "MOCK"
}