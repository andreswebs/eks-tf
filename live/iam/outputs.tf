output "role_arn" {
  value = {
    eks_admin = aws_iam_role.eks_admin.arn
  }
}

output "role_name" {
  value = {
    eks_admin = aws_iam_role.eks_admin.name
  }
}

output "policy_arn" {
  value = {
    s3_requisites_for_ssm = aws_iam_policy.s3_requisites_for_ssm.arn
    ecr_push              = aws_iam_policy.ecr_push.arn
  }
}

output "policy_name" {
  value = {
    s3_requisites_for_ssm = aws_iam_policy.s3_requisites_for_ssm.name
    ecr_push              = aws_iam_policy.ecr_push.name
  }
}
