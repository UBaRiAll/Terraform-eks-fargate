resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {

    endpoint_private_access = true
    endpoint_public_access  = false
    #public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = [
        aws_subnet.pub-subnet-01.id,
        aws_subnet.pub-subnet-02.id,
        aws_subnet.pri-subnet-01.id,
        aws_subnet.pri-subnet-02.id,
        aws_subnet.pri-subnet-03.id,
        aws_subnet.pri-subnet-04.id

    ]
  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]
}




resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster-${var.cluster_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "amazon-eks-cluster-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}


