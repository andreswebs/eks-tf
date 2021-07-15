output "namespace" {
  value       = kubernetes_namespace.px_backup.metadata[0].name
  description = "The name (`metadata.name`) of the namespace"
}
