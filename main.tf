# ---------------------------------------------------------------------------------------------------------------------
# Subnetwork Config
# The default gateway automatically configures public internet access for instances with addresses for 0.0.0.0/0
# External access is configured with Cloud NAT, which serves egress traffic for instances without external addresses
# ---------------------------------------------------------------------------------------------------------------------

locals {
  subnet_keys = [for subnet in var.subnets : try(subnet._resource_key, null) != null ? subnet._resource_key : "${subnet.region}/${subnet.name}"]

  subnets = { for idx, subnet in var.subnets : local.subnet_keys[idx] => subnet }
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each = var.module_enabled ? local.subnets : {}

  project = var.project
  network = var.network
  region  = each.value.region
  name    = each.value.name

  private_ip_google_access = try(each.value.private_ip_google_access, true)
  ip_cidr_range            = cidrsubnet(each.value.ip_cidr_range, 0, 0)

  dynamic "secondary_ip_range" {
    for_each = try(each.value.secondary_ip_ranges, [])

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = try(each.value.log_config != null, false) || var.default_log_config != null ? [1] : []

    content {
      aggregation_interval = try(each.value.log_config.aggregation_interval, var.default_log_config.aggregation_interval, null)
      flow_sampling        = try(each.value.log_config.flow_sampling, var.default_log_config.flow_sampling, null)
      metadata             = try(each.value.log_config.metadata, var.default_log_config.metadata, null)
      metadata_fields      = try(each.value.log_config.metadata_fields, var.default_log_config.metadata_fields, null)
      filter_expr          = try(each.value.log_config.filter_expr, var.default_log_config.filter_expr, null)
    }
  }

  depends_on = [var.module_depends_on]
}
