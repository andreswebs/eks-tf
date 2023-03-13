output "role_arn" {
  value = {
    eks_admin  = var.create_eks_admin_role ? aws_iam_role.eks_admin[0].arn : ""
    eks_worker = module.eks_worker.role.arn
  }
}

output "role_name" {
  value = {
    eks_admin  = var.create_eks_admin_role ? aws_iam_role.eks_admin[0].name : ""
    eks_worker = module.eks_worker.role.name
  }
}

output "profile_name" {
  value = {
    eks_worker = module.eks_worker.instance_profile.id
  }
}
