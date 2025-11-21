# route-kubernetes-http-route

This is a Terraform / OpentTofu compatible module to provision Gateway API `HTTPRoute` resources on top of Kubernetes for the Humanitec platform orchestrator.

If we assume this is used to back a `route` resource type, the developer may use this as:

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

Note that the module produces no outputs, so the resource type doesn't need to declare any.

## Installation

Install this with the `hctl` CLI, you should replace the `CHANGEME` in the module source with the latest release tag, replace the `CHANGEME` in the provider mapping with your real provider type and alias for Kubernetes.

```shell
hctl create module \
    --set=resource_type=k8s-service-account \
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

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->