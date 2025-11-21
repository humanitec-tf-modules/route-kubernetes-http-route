mock_provider "kubernetes" {}

run "test" {
  command = plan

  variables {
    namespace    = "default"
    path         = "/some/path"
    service      = "my-backend"
    service_port = 8080
    hostname     = "example.com"
    gateways     = ["my-gateway"]

    additional_annotations = {
      name = "example-annotation"
    }
    additional_labels = {
      mylabel = "label-value"
    }
    name_prefix       = "route-"
    gateway_namespace = "infra"
    path_match_type   = "Exact"
    filters = [{
      type = "RequestHeaderModifier"
      requestHeaderModifier = {
        add = [{
          name  = "X-Example"
          value = "some-value"
        }]
      }
    }]
  }
}