resource "random_id" "id" {
  byte_length = 8
}

locals {
  service_name_parts = split(".", var.service)
  service_name       = local.service_name_parts[0]
  service_namespace  = length(local.service_name_parts) > 0 ? local.service_name_parts[1] : null
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
        filters = var.filters
        backendRefs = [{
          name      = local.service_name
          namespace = local.service_namespace
          port      = var.service_port
        }]
      }]
    }
  }
}
