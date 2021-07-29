module "grafana_assume_role_policy" {
  source                = "andreswebs/eks-irsa-policy-document/aws"
  cluster_oidc_provider = var.cluster_oidc_provider
  k8s_sa_name           = var.grafana_service_account_name
  k8s_sa_namespace      = local.monitoring_namespace
}

resource "aws_iam_role" "grafana" {
  name                  = "grafana"
  assume_role_policy    = module.grafana_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "grafana_permissions" {
  name   = "grafana-permissions"
  role   = aws_iam_role.grafana.id
  policy = file("${path.module}/policies/grafana-permissions.json")
}
