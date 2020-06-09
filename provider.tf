provider "aws" {
  region = var.aws_region
  version = "~> 2.37"
  shared_credentials_file = "~/.aws/mrau"
  profile = "default"
}
