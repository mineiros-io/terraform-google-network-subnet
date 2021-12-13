header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-module-template"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-module-template/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-module-template/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-module-template.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-module-template/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-network-subnet"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Network Subnet](https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 3._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      A [Terraform] base module for creating `terraform-google-compute-subnetwork` which creates a subnet into a specified VPC. Each VPC network is subdivided into subnets, and each subnet is contained within a single region. You can have more than one subnet in a region for a given VPC network. If no `log_config` is specified `default_log_config` with best practices will be applied.
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-network-subnet" {
        source = "github.com/mineiros-io/terraform-google-network-subnet.git?ref=v0.1.0"

        name          = "test-subnetwork"
        ip_cidr_range = "10.2.0.0/16"
        region        = "us-central1"
        network       = google_compute_network.custom-test.id

        secondary_ip_range {
          range_name    = "tf-test-secondary-range-update1"
          ip_cidr_range = "192.168.10.0/24"
        }
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_depends_on" {
          type           = list(any)
          readme_type    = "list(dependencies)"
          description    = <<-END
            A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
          END
          readme_example = <<-END
            module_depends_on = [
              google_network.network
            ]
          END
        }
      }

      section {
        title = "Main Resource Configuration"

        variable "project" {
          required    = true
          type        = string
          description = <<-END
            The ID of the project in which the resources belong.
          END
        }

        variable "network" {
          required    = true
          type        = string
          description = <<-END
            The VPC network the subnets belong to.
          END
        }

        variable "mtu" {
          type        = string
          default     = "1460"
          description = <<-END
            Maximum Transmission Unit in bytes. The minimum value for this field is 1460 and the maximum value is 1500 bytes.
          END
        }

        variable "subnets" {
          type           = list(any)
          readme_type    = "list(subnets)"
          description    = <<-END
            A list of subnets to be created with the VPC.
          END
          readme_example = <<-END
            subnet = [
            {
              name                     = "kubernetes"
              region                   = "europe-west1"
              private_ip_google_access = false
              ip_cidr_range            = "10.0.0.0/20"
            }]
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the resource, provided by the client when initially creating the resource.
            END
          }

          attribute "region" {
            type        = string
            description = <<-END
              The GCP region for this subnetwork.
            END
          }

          attribute "private_ip_google_access" {
            type        = bool
            default     = true
            description = <<-END
              When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.
            END
          }

          attribute "ip_cidr_range" {
            required    = true
            type        = string
            description = <<-END
              The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported.
            END
          }

          attribute "secondary_ip_ranges" {
            type           = list(any)
            readme_type    = "list(secondary_ip_range)"
            description    = <<-END
              An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.
            END
            readme_example = <<-END
              secondary_ip_range {
                range_name = "tf-test-secondary-range-update1"
                ip_cidr_range        = "192.168.10.0/24"
              }
            END

            attribute "range_name" {
              required    = true
              type        = string
              description = <<-END
                The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.
              END
            }

            attribute "ip_cidr_range" {
              required    = true
              type        = string
              description = <<-END
                The range of IP addresses belonging to this subnetwork secondary range. Provide this property when you create the subnetwork. Ranges must be unique and non-overlapping with all primary and secondary IP ranges within a network. Only `IPv4` is supported.
              END
            }
          }

          attribute "log_config" {
            type           = any
            readme_type    = "object(log_config)"
            description    = <<-END
              An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.
            END
            readme_example = <<-END
              log_config {
                aggregation_interval = "INTERVAL_10_MIN"
                flow_sampling        = 0.5
                metadata             = "INCLUDE_ALL_METADATA"
                metadata_fields      = "CUSTOM_METADATA"
                filter_expr          = true
              }
            END

            attribute "aggregation_interval" {
              type        = string
              description = <<-END
                Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Default is an interval of `5 seconds` per connection. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.
              END
            }

            attribute "flow_sampling" {
              type        = number
              description = <<-END
                Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported.
              END
            }

            attribute "metadata" {
              type        = string
              description = <<-END
                Can only be specified if VPC flow logging for this subnetwork is `enabled`. Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are `EXCLUDE_ALL_METADATA`, `INCLUDE_ALL_METADATA`, and `CUSTOM_METADATA`.
              END
            }

            attribute "metadata_fields" {
              type        = list(string)
              description = <<-END
                List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `"metadata"` is set to `CUSTOM_METADATA`.
              END
            }

            attribute "filter_expr" {
              type        = string
              description = <<-END
                Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field.
              END
            }
          }
        }

        variable "default_log_config" {
          type           = any
          readme_type    = "object(default_log_config)"
          default        = { 
            aggregation_interval = "INTERVAL_10_MIN" 
            flow_sampling = 0.5 
            metadata = "INCLUDE_ALL_METADATA" 
          }
          description    = <<-END
            The default logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples.
          END
          readme_example = <<-END
            default_log_config {
              aggregation_interval = "INTERVAL_10_MIN"
              flow_sampling        = 0.5
              metadata             ="INCLUDE_ALL_METADATA"
            }
          END

          attribute "aggregation_interval" {
            type        = string
            default     = "INTERVAL_10_MIN"
            description = <<-END
              Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.
            END
          }

          attribute "flow_sampling" {
            type        = number
            default     = 0.5
            description = <<-END
              Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported. The
            END
          }

          attribute "metadata" {
            type        = string
            default     = "INCLUDE_ALL_METADATA"
            description = <<-END
              Can only be specified if VPC flow logging for this subnetwork is enabled. Configures whether metadata fields should be added to the reported VPC flow logs.
            END
          }

          attribute "metadata_fields" {
            type        = list(string)
            default     = "CUSTOM_METADATA"
            description = <<-END
              List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `metadata` is set to `CUSTOM_METADATA`.
            END
          }

          attribute "filter_expr" {
            type        = string
            default     = "true"
            description = <<-END
              Export filter used to define which VPC flow logs should be logged, as as CEL expression. See `https://cloud.google.com/vpc/docs/flow-logs#filtering` for details on how to format this field. The default value is `true`, which evaluates to include everything.
            END
          }
        }
      }

      section {
        title = "Extended Resource Configuration"
      }
    }
  }

  section {
    title   = "Module Attributes Reference"
    content = <<-END
      The following attributes are exported in the outputs of the module:

      - **`module_enabled`**

        Whether this module is enabled.

      - **`subnetworks`**

        The created subnet resources.
    END
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation :"
      content = <<-END
        - Configuring Private Google Access: <https://cloud.google.com/vpc/docs/configure-private-google-access>
        - Using VPC networks: <https://cloud.google.com/vpc/docs/using-vpc>
      END
    }

    section {
      title   = "Terraform Google Provider Documentation :"
      content = <<-END
        - <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#flow_sampling>
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in ` 0.0.z ` and ` 0.y.z ` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage"{
    value = "https : //mineiros.io/?ref=terraform-google-network-subnet"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-module-template.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "badge-tf-gcp" {
    value = "https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform"
  }
  ref "releases-google-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-google/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "gcp" {
    value = "https://cloud.google.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/CONTRIBUTING.md"
  }
}
