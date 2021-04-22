output "namespace" {
  value       = kubernetes_namespace.monitoring.metadata[0].name
  description = "The name (metadata.name) of the namespace"
}
