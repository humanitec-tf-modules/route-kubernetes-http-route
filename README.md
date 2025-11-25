# route-kubernetes-http-route

This is a Terraform / OpenTofu compatible module to provision [Gateway API `HTTPRoute`](https://kubernetes.io/docs/concepts/services-networking/gateway/#api-kind-httproute) resources on top of Kubernetes for the Humanitec Platform Orchestrator.

If we assume this is used to back a `route` resource type, the developer may use it like this in a deploment manifest:

```yaml
workloads:
  main:
    resources:
      score-workload:
        type: score-workload
        ...
      route:
        type: route
        params:
          hostname: ${resources.dns.outputs.hostname}
          path: /control
          service: ${resources.score-workload.outputs.endpoint}
          service_port: 8080
```

## Requirements

1. There must be a module provider setup for `kubernetes` (`hashicorp/kubernetes`).
2. There must be a resource type setup for `route`, for example:

    ```shell
    hctl create resource-type route --set=description='Kubernetes HTTP Route' --set=output_schema='{"type":"object","properties":{}}'
    ```

Note that the module produces no resource outputs other than metadata, so the resource type doesn't need to declare any output schema.

## Installation

Install this with the `hctl` CLI, you should replace the `CHANGEME` in the module source with the latest release tag, replace the `CHANGEME` in the provider mapping with your real provider type and alias for Kubernetes.

```shell
hctl create module \
    --set=resource_type=route \
    --set=module_source=git::https://github.com/humanitec-tf-modules/route-kubernetes-http-route?ref=CHANGEME \
    --set=provider_mapping='{"kubernetes": "CHANGEME"}' \
    --set=dependencies='{"ns":{"type":"k8s-namespace","id":"env-namespace"}}' \
    --set=module_inputs='{"namespace": "${resources.ns.outputs.name}", "gateways": ["default-gateway"], "gateway_namespace": "default"}' \
    --set=module_params='{"hostname":{"type":"string"},"path":{"type":"string"},"service":{"type":"string"},"service_port":{"type":"number"}}'
```

The `namespace`, `path`, `service`, `service_port`, `hostname`, and `gateways` are required inputs and must be configured either in the `module_inputs` or defined in the `module_params` for the developer/user to set. In the example above, we expect the
`hostname`, `path`, `service`, and `service_port` to come from the developer params, while the remaining parameters are set by the platform engineer to point to a Gateway that has already been provisioned and a namespace that is configured as part of the graph.

You can also use any of the input parameters described further down this document to modify the behavior.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.route](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_annotations"></a> [additional\_annotations](#input\_additional\_annotations) | Additional annotations to add to the http route. | `map(string)` | `null` | no |
| <a name="input_additional_labels"></a> [additional\_labels](#input\_additional\_labels) | Additional labels to add to the http route. | `map(string)` | `null` | no |
| <a name="input_filters"></a> [filters](#input\_filters) | Additional Gateway HTTPRoute filters to inject on this route | `list(any)` | `null` | no |
| <a name="input_gateway_namespace"></a> [gateway\_namespace](#input\_gateway\_namespace) | The namespace of the var.gateways | `string` | `null` | no |
| <a name="input_gateways"></a> [gateways](#input\_gateways) | The name of the Gateway API Gateways to connect this route to | `list(string)` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname to match traffic to this route | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to create route in, this should be the same namespace as the backing service | `string` | n/a | yes |
| <a name="input_path"></a> [path](#input\_path) | The path to match | `string` | n/a | yes |
| <a name="input_path_match_type"></a> [path\_match\_type](#input\_path\_match\_type) | The path match strategy | `string` | `"PathPrefix"` | no |
| <a name="input_service"></a> [service](#input\_service) | The service name to route traffic to within the cluster | `string` | n/a | yes |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | The service port to route traffic to | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_humanitec_metadata"></a> [humanitec\_metadata](#output\_humanitec\_metadata) | Metadata for Humanitec. |
<!-- END_TF_DOCS -->