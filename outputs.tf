output "humanitec_metadata" {
  description = "Metadata for Humanitec."
  value = {
    "Kubernetes-Namespace"  = var.namespace
    "Kubernetes-Http-Route" = lookup(kubernetes_manifest.route.manifest.metadata, "name", "")
  }
}
