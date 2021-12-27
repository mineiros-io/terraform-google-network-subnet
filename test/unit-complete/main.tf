# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPLETE FEATURES UNIT TEST
# This module tests a complete set of most/all non-exclusive features
# The purpose is to activate everything the module offers, but trying to keep execution time and costs minimal.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "gcp_region" {
  type        = string
  description = "(Required) The gcp region in which all resources will be created."
}

variable "gcp_project" {
  type        = string
  description = "(Required) The ID of the project in which the resource belongs."
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

module "vpc" {
  source = "github.com/mineiros-io/terraform-google-network-vpc?ref=v0.0.2"

  project = var.gcp_project
  name    = "unit-complete"
}

# DO NOT RENAME MODULE NAME
module "test" {
  source = "../.."

  module_enabled = true

  # add all required arguments
  network = module.vpc.vpc.id
  subnets = [
    {
      name          = "unit-complete-public"
      description   = "A public subnetwork"
      region        = "europe-west3",
      ip_cidr_range = "10.0.0.0/24"
      secondary_ip_ranges = [
        {
          range_name    = "unit-complete-public-secondary"
          ip_cidr_range = "10.1.0.0/16"
        }
      ]
      log_config = {
        aggregation_interval = "INTERVAL_10_MIN"
        flow_sampling        = 0.5
        metadata             = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name          = "unit-complete-private"
      region        = "europe-west3",
      ip_cidr_range = "10.0.1.0/24"
      secondary_ip_ranges = [
        {
          range_name    = "unit-complete-private-secondary"
          ip_cidr_range = "10.2.0.0/16"
        }
      ]
    },
  ]
  # add all optional arguments that create additional resources

  # add most/all other optional arguments
  default_log_config = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  module_timeouts = {
    google_compute_subnetwork = {
      create = "10m"
      update = "10m"
      delete = "10m"
    }
  }

  module_depends_on = ["nothing"]
}

# outputs generate non-idempotent terraform plans so we disable them for now unless we need them.
# output "all" {
#   description = "All outputs of the module."
#   value       = module.test
# }
