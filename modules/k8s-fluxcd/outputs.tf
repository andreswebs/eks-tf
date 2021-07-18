output "namespace" {
  value       = kubernetes_namespace.flux.metadata[0].name
  description = "The name (metadata.name) of the namespace"
}
