# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "network" {
  description = "(Required) The VPC network the subnets belong to."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  type        = string
  description = "(Optional) The ID of the project in which the resource belongs. If it is not set, the provider project is used."
  default     = null
}

variable "mtu" {
  description = "(Optional) Maximum Transmission Unit in bytes. The minimum value for this field is 1460 and the maximum value is 1500 bytes. Default is '1460'."
  type        = string
  default     = 1460

  validation {
    condition     = var.mtu >= 1460 && var.mtu <= 1500
    error_message = "The mtu expects a value between '1460' and '1500'."
  }
}

variable "subnets" {
  # TODO implement validation
  description = "(Optional) A list of subnets to be created with the VPC. Default is 'null'."
  type        = any
  default     = null

  # Example
  #
  # subnets = [
  #   {
  #     name                     = "kubernetes",
  #     region                   = "europe-west1"
  #     private_ip_google_access = false,
  #     ip_cidr_range            = "10.0.0.0/20"
  #     secondary_ip_ranges = [{
  #       range_name    = "kubernetes-pods"
  #       ip_cidr_range = "10.10.0.0/20"
  #     }]
  #     log_config = {
  #       aggregation_interval = "INTERVAL_10_MIN"
  #       flow_sampling        = 0.5
  #       metadata             = "INCLUDE_ALL_METADATA"
  #       metadat_fields       = null
  #       filter_expr          = null
  #     }
  #   },
  #   {
  #     class                    = "public",
  #     region                   = "europe-west1",
  #     private_ip_google_access = false,
  #     ip_cidr_range            = "10.20.0.0/16"
  #   }
  # ]
}

variable "default_log_config" {
  description = "(Optional) The default logging options for the subnetwork flow logs. Setting this value to 'null' will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples. Default is '{ aggregation_interval = \"INTERVAL_10_MIN\" flow_sampling = 0.5 metadata = \"INCLUDE_ALL_METADATA\" }'."
  # type = object({
  #   aggregation_interval = string
  #   flow_sampling        = number
  #   metadata             = string
  #   metadata_fields      = list(string)
  #   filter_expr          = string
  # })
  default = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  #   validation {
  #     condition = can(regex("^(INTERVAL_5_SEC|INTERVAL_30_SEC|INTERVAL_1_MIN| INTERVAL_5_MIN|INTERVAL_10_MIN|INTERVAL_15_MIN)$", var.default_log_config.aggregation_interval))
  #
  #     error_message = "The 'aggregation_interval' property of the 'log_config' variable expects one of the following values 'INTERVAL_5_SEC', 'INTERVAL_30_SEC', 'INTERVAL_1_MIN', 'INTERVAL_5_MIN', 'INTERVAL_10_MIN' or 'INTERVAL_15_MIN."
  #   }
  #
  #   validation {
  #     condition = var.default_log_config.flow_sampling >= 0 && var.default_log_config.flow_sampling <= 1
  #
  #     error_message = "The value of the 'flow_sampling' property of the 'log_config' variable must be in [0, 1]. Set the sampling rate of VPC flow logs within the subnetwork where 1.0 means all collected logs are reported and 0.0 means no logs are reported."
  #   }
  #
  #   validation {
  #     condition = can(regex("^(INCLUDE_ALL_METADATA|EXCLUDE_ALL_METADATA|CUSTOM_METADATA)$", var.default_log_config.metadata))
  #
  #     error_message = "The 'metadata' property of the 'log_config' variable expects one of the following values 'INCLUDE_ALL_METADATA', 'EXCLUDE_ALL_METADATA' or 'CUSTOM_METADATA'."
  #   }

  # TOOD implement validation for metadata_fields and filter_expr
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether or not to create resources within the module."
  default     = true
}

variable "module_timeouts" {
  description = "(Optional) How long certain operations (per resource type) are allowed to take before being considered to have failed."
  type        = any
  # type = object({
  #   google_compute_subnetwork = optional(object({
  #     create = optional(string)
  #     update = optional(string)
  #     delete = optional(string)
  #   }))
  # })
  default = {}
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends on."
  default     = []
}
