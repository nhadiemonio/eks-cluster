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

variable "key-pairs-vars" {
  type = map
  default = {
    rramos = {
      key_name = "rramos"
      pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN7fwbzIOEiEHxMbw0CWmFjnzmjbVdNLZ8m2srO/NE0bTb9lWd8L4QtcWAAmuToatR0ZQE5Tuhk0diuUMaDsJLOpuED7Z+6dPbIVd8ge+OcCU1KQUDjJC5I3grNEedROfPyYvlkjh1JU0ZgSB8prqActR57J59zAhzSfIuM5zOZL1NUNLGR2CLbLFZR5cB1atL2OLOuAEKl/u4yTYgr4hwcSLNbw5gvN1VZSqnAbPyT0B6UgjAp/Irlg2OFnV39ZHzbiri2ZJ7GOGs9wyQ4MNGspkm7B0bX1YFpuFy5N8SBkjWitcJum/9cgO2C5yuAXtWfWAwGK4+krG+I1B3ximt rramos"
    }
  }
}
