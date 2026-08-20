terraform {
  required_version = ">= 1.5"

  # Os dados do backend sao fornecidos no `terraform init`.
  # Assim, o mesmo codigo funciona localmente e no GitHub Actions
  # sem fixar o numero de uma conta AWS no repositorio.
  backend "s3" {}

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
