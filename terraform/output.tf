output "cluster_name" {
  value = aws_eks_cluster.assignment.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.assignment.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.assignment.certificate_authority[0].data
}

output "aws_iam_role_arn" {
  value       = aws_iam_role.assignment.arn
}