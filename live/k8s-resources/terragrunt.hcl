include {
  path = find_in_parent_folders()
}

dependency "iam" {
  config_path = "${path_relative_from_include()}/iam"
}

dependency "k8s" {
  config_path = "${path_relative_from_include()}/k8s"
}

dependency "route53" {
  config_path = "${path_relative_from_include()}/route53"
}

locals {
  config = yamldecode(file(find_in_parent_folders("config.yml")))
  manifest_metrics_server = "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  manifest_aws_lb_controller = "https://github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
}

inputs = {
  aws_region = local.config.aws_region
  eks_admin_role_arn = dependency.iam.outputs.role_arn.eks_admin
  eks_cluster_id = dependency.k8s.outputs.cluster_id
  acm_cert_arn = dependency.route53.outputs.cert_arn
  k8s_monitoring_namespace = local.config.k8s_monitoring_namespace
}

terraform {

  before_hook "metrics_server" {
    commands     = ["apply"]
    execute      = ["kubectl", "apply", "-f", local.manifest_metrics_server]
    run_on_error = true
  }

  before_hook "aws_lb_controller" {
    commands     = ["apply"]
    execute      = ["kubectl", "apply", "-k", local.manifest_aws_lb_controller]
    run_on_error = true
  }

}
