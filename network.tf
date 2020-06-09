# Create EKS VPC
resource "aws_vpc" "eks-vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "eks-vpc"
    Environment = terraform.workspace
  }
}

# Create public subnet for each Availability Zone
resource "aws_subnet" "eks-public-subnet" {
  depends_on = [aws_vpc.eks-vpc]
  for_each = var.subnet
  cidr_block = each.value["public_subnet_cidr"]
  availability_zone = each.key
  vpc_id = aws_vpc.eks-vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-subnet"
    Environment = terraform.workspace
  }
}

# Create private subnet for each Availability Zone
resource "aws_subnet" "eks-private-subnet" {
  depends_on = [aws_vpc.eks-vpc]
  for_each = var.subnet
  cidr_block = each.value["private_subnet_cidr"]
  availability_zone = each.key
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "eks-private-subnet"
    Environment = terraform.workspace
  }
}

# Create Internet Gateway for VPC
resource "aws_internet_gateway" "eks-igw" {
  depends_on = [aws_vpc.eks-vpc]
  vpc_id = aws_vpc.eks-vpc.id
  tags = {
    Name = "eks-igw"
    Environment = terraform.workspace
  }
}

# Request EIP for NATGW
resource "aws_eip" "eks-natgw-eip" {
  depends_on = [aws_vpc.eks-vpc,aws_internet_gateway.eks-igw]
  for_each = var.subnet
  vpc = true
  tags = {
    Name = "eks-natgw-eip"
    Environment = terraform.workspace
  }
}

# Create NAT GW for each Availability Zone
resource "aws_nat_gateway" "eks-natgw" {
  depends_on = [aws_eip.eks-natgw-eip,aws_subnet.eks-private-subnet]
  for_each = var.subnet
  allocation_id = aws_eip.eks-natgw-eip["${each.key}"].id
  subnet_id = aws_subnet.eks-public-subnet["${each.key}"].id
  tags = {
    Name = "eks-natgw"
    Environment = terraform.workspace
  }
}

# Create routing table for public subnet
resource "aws_route_table" "public-subnet-route-table" {
  depends_on = [aws_vpc.eks-vpc,aws_internet_gateway.eks-igw]
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }
  tags = {
    Name = "public-subnet-route-table"
    Environment = terraform.workspace
  }
}

# Create routing table for private subnet
resource "aws_route_table" "private-subnet-route-table" {
  depends_on = [aws_vpc.eks-vpc,aws_nat_gateway.eks-natgw]
  for_each = var.subnet
  vpc_id = aws_vpc.eks-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.eks-natgw["${each.key}"].id
  }
  tags = {
    Name = "private-subnet-route-table"
    Environment = terraform.workspace
  }
}

# Associate Routing table to public-subnet
resource "aws_route_table_association" "public-subnet-route-table-association" {
  depends_on = [aws_route_table.public-subnet-route-table]
  for_each = var.subnet
  route_table_id = aws_route_table.public-subnet-route-table.id
  subnet_id = aws_subnet.eks-public-subnet["${each.key}"].id
}

# Associate Routing table to private-subnet
resource "aws_route_table_association" "private-subnet-route-table-association" {
  depends_on = [aws_route_table.private-subnet-route-table]
  for_each = var.subnet
  route_table_id = aws_route_table.private-subnet-route-table["${each.key}"].id
  subnet_id = aws_subnet.eks-private-subnet["${each.key}"].id
}







