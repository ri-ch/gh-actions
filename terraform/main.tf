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

resource "aws_s3_bucket" "application-data-bucket" {
  bucket = "napi-application-data-bucket"
  acl    = "private"
}