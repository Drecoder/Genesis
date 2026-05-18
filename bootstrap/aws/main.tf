terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Mock network resource for outputs.tf to reference
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "vpc-genesis-bootstrap-${var.environment}"
    Environment = var.environment
  }
}

# Mock identity resource for outputs.tf to reference
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["69a50c825144d05cefaa5b2f1153414d2b5465c2"]
}