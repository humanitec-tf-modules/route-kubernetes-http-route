// REQUIRED

variable "namespace" {
  type        = string
  description = "The namespace to create route in, this should be the same namespace as the backing service"
}

variable "path" {
  type        = string
  description = "The path to match"
}

variable "service" {
  type        = string
  description = "The service name to route traffic to within the cluster"
}

variable "service_port" {
  type        = number
  description = "The service port to route traffic to"
}

variable "hostname" {
  type        = string
  description = "The hostname to match traffic to this route"
}

variable "gateways" {
  type        = list(string)
  description = "The name of the Gateway API Gateways to connect this route to"

  validation {
    condition     = length(var.gateways) > 0
    error_message = "Must define at least one gateway name"
  }
}

// OPTIONALS

variable "additional_annotations" {
  type        = map(string)
  description = "Additional annotations to add to the service account."
  default     = {}
}

variable "additional_labels" {
  type        = map(string)
  description = "Additional labels to add to the service account."
  default     = {}
}

variable "name_prefix" {
  type        = string
  description = "The name prefix to use for the generated http route"
  default     = "route-"
}

variable "gateway_namespace" {
  type        = string
  description = "The namespace of the var.gateways"
  default     = null
}

variable "path_match_type" {
  type        = string
  default     = "Prefix"
  description = "The path match strategy"

  validation {
    condition     = var.path_match_type == "Prefix" || var.path_match_type == "Exact" || var.path_match_type == "RegularExpression"
    error_message = "path_match_type must be Prefix, Exact, or RegularExpression"
  }
}

variable "filters" {
  type        = list(any)
  description = "Additional Gateway HTTPRoute filters to inject on this route"
  default     = []
}
