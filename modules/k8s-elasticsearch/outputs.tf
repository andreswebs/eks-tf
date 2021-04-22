output "namespace" {
  value       = kubernetes_namespace.elastic.metadata[0].name
  description = "The name (metadata.name) of the namespace"
}
