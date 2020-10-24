provider "aws" {
  region = "eu-west-2"
}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "tf-state-rc-napi"
    region = "eu-west-2"
    key = "napi.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}