resource "random_id" "id" {
  byte_length = 8
}

locals {
  service_name = split(".", var.service)[0]
}

resource "kubernetes_manifest" "route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace   = var.namespace
      name        = "route-${local.service_name}-${random_id.id.hex}"
      annotations = var.additional_annotations
      labels      = var.additional_labels
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
          name = local.service_name
          port = var.service_port
        }]
      }]
    }
  }
  computed_fields = ["metadata.name"]
}
