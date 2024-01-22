provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}


# run this first:
# aws s3 mb s3://nomad-ai-tfstate

terraform {
  backend "s3" {
    bucket  = "nomad-ai-tfstate"
    key     = "nomad-ai.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}
