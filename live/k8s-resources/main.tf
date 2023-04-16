# module "monitoring" {
#   source                        = "andreswebs/eks-monitoring/aws"
#   version                       = "0.12.0"
#   k8s_namespace                 = var.k8s_monitoring_namespace
#   cluster_oidc_provider         = local.cluster_oidc_provider
#   create_loki_storage           = true
#   loki_storage_s3_force_destroy = true
#   prometheus_enabled            = false
#   loki_storage_s3_bucket_name   = "${var.eks_cluster_name}-loki"
# }

# module "aws_lb_controller" {
#   source                = "andreswebs/eks-lb-controller/aws"
#   version               = "1.2.0"
#   cluster_name          = data.aws_eks_cluster.cluster.name
#   cluster_oidc_provider = local.cluster_oidc_provider
# }

# module "chartmuseum" {
#   source                = "andreswebs/eks-chartmuseum/aws"
#   version               = "1.0.0"
#   depends_on            = [module.fluxcd]
#   s3_bucket_name        = var.chartmuseum_s3_bucket_name
#   s3_object_key_prefix  = var.chartmuseum_s3_object_key_prefix
#   k8s_namespace         = local.flux_namespace
#   cluster_oidc_provider = local.cluster_oidc_provider
# }
