# EKS Cluster
resource "aws_eks_cluster" "my-eks" {
  depends_on = [aws_iam_role.eksClusterRole,aws_iam_role_policy_attachment.eksClusterRoleAttachPolicy]
  name = "my-eks"
  role_arn = aws_iam_role.eksClusterRole.arn
  vpc_config {
    subnet_ids = [
      # Need to figure out how to loop inside a variable
      aws_subnet.eks-public-subnet["ap-southeast-1a"].id,
      aws_subnet.eks-public-subnet["ap-southeast-1b"].id,
      aws_subnet.eks-public-subnet["ap-southeast-1c"].id,
      aws_subnet.eks-private-subnet["ap-southeast-1a"].id,
      aws_subnet.eks-private-subnet["ap-southeast-1b"].id,
      aws_subnet.eks-private-subnet["ap-southeast-1c"].id
    ]
    security_group_ids = [
      aws_security_group.allow-all-inbound.id
    ]
    endpoint_private_access = true
    endpoint_public_access = true
  }
}

# EKS Node Group
resource "aws_eks_node_group" "my-eks-worker-nodes" {
  depends_on = [aws_eks_cluster.my-eks,aws_iam_role.eksNodeRole]
  cluster_name = aws_eks_cluster.my-eks.name
  node_group_name = "my-eks-worker-nodes"
  node_role_arn = aws_iam_role.eksNodeRole.arn
  # Need to figure out how to loop inside a variable
  subnet_ids = [
    # Need to figure out how to loop inside a variable
    aws_subnet.eks-private-subnet["ap-southeast-1a"].id,
    aws_subnet.eks-private-subnet["ap-southeast-1b"].id,
    aws_subnet.eks-private-subnet["ap-southeast-1c"].id
  ]
  scaling_config {
    desired_size = 3
    max_size = 3
    min_size = 3
  }
}
