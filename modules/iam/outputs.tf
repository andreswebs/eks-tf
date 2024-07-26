output "eks_worker_role_arn" {
  value = var.create_eks_worker_role ? module.eks_worker[0].role.arn : null
}

output "eks_admin_role_arn" {
  value = var.create_eks_admin_role ? aws_iam_role.eks_admin[0].arn : null
}

output "roles" {
  value = {
    eks_admin  = var.create_eks_admin_role ? aws_iam_role.eks_admin[0].arn : null
    eks_worker = var.create_eks_worker_role ? module.eks_worker[0].role.arn : null
  }
}
