# Source: https://learn.hashicorp.com/collections/terraform/aws-get-started.

terraform {
  backend "remote" {
    organization = "test-organisation"

    workspaces {
      name = "test-workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_instance" "app_server" {
  #ami           = "ami-038d7b856fe7557b3"
  ami           = "ami-028188d9b49b32a80"
  instance_type = "t2.micro"

  tags = {
    #Name = "ExampleAppServerInstance"
    Name = var.instance_name
  }
}
