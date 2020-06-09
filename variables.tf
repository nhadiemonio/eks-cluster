variable "aws_region" {
  default = "ap-southeast-1"
}

variable "vpc_cidr_block" {
  default = "10.128.0.0/16"
}

variable "subnet" {
  type = map
  default = {
    ap-southeast-1a = {
      public_subnet_cidr = "10.128.0.0/22"
      private_subnet_cidr = "10.128.16.0/22"
    },
    ap-southeast-1b = {
      public_subnet_cidr = "10.128.4.0/22"
      private_subnet_cidr = "10.128.20.0/22"
    },
    ap-southeast-1c = {
      public_subnet_cidr = "10.128.8.0/22"
      private_subnet_cidr = "10.128.24.0/22"
    }
  }
}