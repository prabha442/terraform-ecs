provider "aws" {
  
 #if you are running from AWS linux instance please use bellow credentials section
  region     = var.aws_region
  shared_credentials_files = ["$HOME/.aws/credentials"]
  
}


terraform {
  backend "s3" {
    bucket = "ecsbucket2022"
    key    = "ecs/terraform.tfstate"
    region = "us-east-1"
  }
}

