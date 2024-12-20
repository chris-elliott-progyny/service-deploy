output "env_name" {
  description = "Environment Name"
  value       = var.env_name
}

output "service_name" {
  description = "Service Name"
  value       = var.service_name
}

output "iam_role" {
  description = "Iam role"
  value       = module.service_iam_role
}

# output "iam_access" {
#   description = "Iam role policies"
#   value       = local.iam_access
# }

output "eks_cluster_identity_oidc_issuer" {
  description = "EKS cluster"
  value       = replace(data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer, "https://", "")
}
