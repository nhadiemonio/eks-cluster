# EKS Cluster IAM Roles
resource "aws_iam_role" "eksClusterRole" {
  name = "eksClusterRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "eksClusterRole"
  }
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "eksClusterRoleAttachPolicy" {
  depends_on = [aws_iam_role.eksClusterRole]
  role       = aws_iam_role.eksClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS Node IAM Roles
resource "aws_iam_role" "eksNodeRole" {
  name = "eksNodeRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "eksNodeRole"
  }
}

# AmazonEKSWorkerNodePolicy Managed Policy
resource "aws_iam_role_policy_attachment" "eksWorkerNodeAttachPolicy" {
  depends_on = [aws_iam_role.eksNodeRole]
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# AmazonEC2ContainerRegistryReadOnly Managed Policy
resource "aws_iam_role_policy_attachment" "eksContainerRegistryAttachPolicy" {
  depends_on = [aws_iam_role.eksNodeRole]
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# AmazonEKS_CNI_Policy Managed Policy
resource "aws_iam_role_policy_attachment" "eksCNIAttachPolicy" {
  depends_on = [aws_iam_role.eksNodeRole]
  role       = aws_iam_role.eksNodeRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
