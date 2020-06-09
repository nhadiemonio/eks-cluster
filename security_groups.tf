resource "aws_default_security_group" "default-public-sec-group" {
  depends_on = [aws_vpc.eks-vpc]
  vpc_id = aws_vpc.eks-vpc.id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name = "allow-all-outbound"
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "allow-all-inbound" {
  depends_on = [aws_vpc.eks-vpc]
  vpc_id = aws_vpc.eks-vpc.id
  name = "allow-all-inbound"
  description = "allow-all-inbound"
  tags = {
    Name = "allow-all-inbound"
    Environment = terraform.workspace
  }
}

resource "aws_security_group_rule" "allow-all-inbound-rules" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.allow-all-inbound.id
  to_port = 0
  type = "ingress"
}