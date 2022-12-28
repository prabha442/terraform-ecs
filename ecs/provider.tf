provider "aws" {
 # access_key = "add-your-key"
 # secret_key = "add-your-access_key"
  
 #if you are running from AWS linux instance please use bellow credentials section
  region     = var.aws_region
  shared_credentials_file = "$HOME/.aws/credentials"
  
}
