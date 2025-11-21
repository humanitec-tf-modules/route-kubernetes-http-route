resource "kubernetes_manifest" "route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace     = var.namespace
      generate_name = var.name_prefix
      annotations   = var.additional_annotations
      labels        = var.additional_labels
    }
    spec = {
      parentRefs = [for n in var.gateways : merge({ name = n }, var.gateway_namespace != null ? { namespace = var.gateway_namespace } : {})]
      hostnames  = [var.hostname]
      rules = [{
        matches = [{
          path = {
            type  = var.path_match_type
            value = var.path
          }
        }]
        backendRefs = [{
          name = split(".", var.service)[0]
          port = var.service_port
        }]
      }]
    }
  }
  computed_fields = ["metadata.name"]
}
