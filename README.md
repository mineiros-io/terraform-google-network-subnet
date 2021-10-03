[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Terraform Version][badge-terraform]][releases-terraform]
[![Google Provider Version][badge-tf-gcp]][releases-google-provider]
[![Join Slack][badge-slack]][slack]

# terraform-google-network-subnet

A [Terraform](https://www.terraform.io) module to create a [Google Network Subnet](https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets) on [Google Cloud Services (GCP)](https://cloud.google.com/).


**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [terraform-google-network-subnet](#terraform-google-network-subnet)
  - [Module Features](#module-features)
  - [Getting Started](#getting-started)
  - [Module Argument Reference](#module-argument-reference)
    - [Top-level Arguments](#top-level-arguments)
      - [Module Configuration](#module-configuration)
      - [Main Resource Configuration](#main-resource-configuration)
      - [Extended Resource Configuration](#extended-resource-configuration)
  - [Module Attributes Reference](#module-attributes-reference)
  - [External Documentation](#external-documentation)
    - [Google Documentation:](#google-documentation)
    - [Terraform Google Provider Documentation:](#terraform-google-provider-documentation)
  - [Module Versioning](#module-versioning)
    - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
  - [About Mineiros](#about-mineiros)
  - [Reporting Issues](#reporting-issues)
  - [Contributing](#contributing)
  - [Makefile Targets](#makefile-targets)
  - [License](#license)

## Module Features

A [Terraform] base module for creating `terraform-google-compute-subnetwork` which creates a subnet into a specified VPC. Each VPC network is subdivided into subnets, and each subnet is contained within a single region. You can have more than one subnet in a region for a given VPC network. If no `log_config` is specified `default_log_config` with best practices will be applied.

## Getting Started

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

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: _(Optional `bool`)_

  Specifies whether resources in the module will be created.

  Default is `true`.

- **`module_depends_on`**: _(Optional `list(dependencies)`)_

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:
  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- **`project`**: **_(Required `string`)_**

  The ID of the project in which the resources belong.

- **`network`**: **_(Required `string`)_**

  The VPC network the subnets belong to.

- **`mtu`**: _(Optional `string`)_

  Maximum Transmission Unit in bytes. The minimum value for this field is 1460 and the maximum value is 1500 bytes.

  Default is `1460`.

- **`subnets`**: _(Optional `list(subnets)`)_

  A list of subnets to be created with the VPC.

  Each `subnet` object can have the following fields:

  Example

  ```hcl
  subnet = [
  {
    name                     = "kubernetes"
    region                   = "europe-west1"
    private_ip_google_access = false
    ip_cidr_range            = "10.0.0.0/20"
  }]
  ```

  - **`name`**: **_(Required `string`)_**

    The name of the resource, provided by the client when initially creating the resource.

  - **`region`**: _(Optional `string`)_

    The GCP region for this subnetwork.

  - **`private_ip_google_access`**: _(Optional `bool`)_

    When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.

    Default `true`

  - **`ip_cidr_range`**: **_(Required `string`)_**

    The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported.

  - **`secondary_ip_ranges`**: _(Optional `list(secondary_ip_range)`)_

    An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.

    Each `secondary_ip_range` object can have the following fields:

    Example

    ```hcl
    secondary_ip_range {
      range_name = "tf-test-secondary-range-update1"
      ip_cidr_range        = "192.168.10.0/24"
    }
    ```

    - **`range_name`**: **_(Required `string`)_**

      The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.

    - **`ip_cidr_range`**: **_(Required `string`)_**

      The range of IP addresses belonging to this subnetwork secondary range. Provide this property when you create the subnetwork. Ranges must be unique and non-overlapping with all primary and secondary IP ranges within a network. Only `IPv4` is supported.

  - **`log_config`**: _(Optional `object(log_config)`)_

    An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.

    Each `log_config` object can have the following fields:

    Example

    ```hcl
    log_config {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
      metadata_fields      = "CUSTOM_METADATA"
      filter_expr          = true
    }
    ```

    - **`aggregation_interval`**: _(Optional `string`)_

      Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Default is an interval of `5 seconds` per connection. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.

    - **`flow_sampling`**: _(Optional `number`)_

      Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported.

    - **`metadata`**: _(Optional `string`)_

      Can only be specified if VPC flow logging for this subnetwork is `enabled`. Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are `EXCLUDE_ALL_METADATA`, `INCLUDE_ALL_METADATA`, and `CUSTOM_METADATA`.

    - **`metadata_fields`**: _(Optional `list(string)`)_

      List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `"metadata"` is set to `CUSTOM_METADATA`.

    - **`filter_expr `**: _(Optional `string`)_

      Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field.

- **`default_log_config`**: _(Optional `object(default_log_config)`)_

  The default logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples.

  Default is `{ aggregation_interval = \"INTERVAL_10_MIN\" flow_sampling = 0.5 metadata = \"INCLUDE_ALL_METADATA\" }`.

  Each `default_log_config` object can have the following fields:

      Example

    ```hcl
    default_log_config {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
    ```

  - **`aggregation_interval`**: _(Optional `string`)_

    Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.

    Default is `INTERVAL_5_SEC`

  - **`flow_sampling`**: _(Optional `number`)_

    Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported. The Default means half of all collected logs are reported.

    Default is `0.5`

  - **`metadata`**: _(Optional `string`)_

    Can only be specified if VPC flow logging for this subnetwork is enabled. Configures whether metadata fields should be added to the reported VPC flow logs. Default value is `INCLUDE_ALL_METADATA`. Possible values are `EXCLUDE_ALL_METADATA`, `INCLUDE_ALL_METADATA`, and `CUSTOM_METADATA`.

    Default is `INCLUDE_ALL_METADATA`

  - **`metadata_fields`**: _(Optional `list(string)`)_

    List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `metadata` is set to `CUSTOM_METADATA`.

    Default is `CUSTOM_METADATA`

  - **`filter_expr`**: _(Optional `string`)_

    Export filter used to define which VPC flow logs should be logged, as as CEL expression. See `https://cloud.google.com/vpc/docs/flow-logs#filtering` for details on how to format this field. The default value is `true`, which evaluates to include everything.

    Default is `true`

#### Extended Resource Configuration

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`subnetworks`**

  The created subnet resources.

## External Documentation

### Google Documentation:

- Configuring Private Google Access: <https://cloud.google.com/vpc/docs/configure-private-google-access>
- Using VPC networks: <https://cloud.google.com/vpc/docs/using-vpc>

### Terraform Google Provider Documentation:

- <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#flow_sampling>

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-network-subnet
[hello@mineiros.io]: mailto:hello@mineiros.io

<!-- markdown-link-check-disable -->

[badge-build]: https://github.com/mineiros-io/terraform-google-network-subnet/workflows/Tests/badge.svg

<!-- markdown-link-check-enable -->

[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-module-template.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-enable -->

[build-status]: https://github.com/mineiros-io/terraform-google-network-subnet/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-network-subnet/releases

<!-- markdown-link-check-enable -->

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/

<!-- markdown-link-check-enable -->

[variables.tf]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-network-subnet/issues
[license]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-network-subnet/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/CONTRIBUTING.md

<!-- markdown-link-check-enable -->
