provider "aws" {
  region  = var.region

  default_tags {
    tags = {
      deploy_type   = var.deploy_type
      environment   = var.environment
      project_name  = var.project_name
    }
  }
}



terraform {
  backend "local" {}
}
