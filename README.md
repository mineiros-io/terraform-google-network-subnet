[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-network-subnet)

[![Build Status](https://github.com/mineiros-io/terraform-google-network-subnet/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-network-subnet/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-network-subnet.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-network-subnet/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-network-subnet

A [Terraform](https://www.terraform.io) module to create a [Google Network Subnet](https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets) on [Google Cloud Services (GCP)](https://cloud.google.com/).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 3._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
  - [Google Documentation :](#google-documentation-)
  - [Terraform Google Provider Documentation :](#terraform-google-provider-documentation-)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in ` 0.0.z ` and ` 0.y.z ` version](#backwards-compatibility-in--00z--and--0yz--version)
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

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependencies)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

  Example:

  ```hcl
  module_depends_on = [
    google_network.network
  ]
  ```

#### Main Resource Configuration

- [**`project`**](#var-project): *(**Required** `string`)*<a name="var-project"></a>

  The ID of the project in which the resources belong.

- [**`network`**](#var-network): *(**Required** `string`)*<a name="var-network"></a>

  The VPC network the subnets belong to.

- [**`mtu`**](#var-mtu): *(Optional `string`)*<a name="var-mtu"></a>

  Maximum Transmission Unit in bytes. The minimum value for this field is 1460 and the maximum value is 1500 bytes.

  Default is `"1460"`.

- [**`subnets`**](#var-subnets): *(Optional `list(subnets)`)*<a name="var-subnets"></a>

  A list of subnets to be created with the VPC.

  Example:

  ```hcl
  subnet = [
  {
    name                     = "kubernetes"
    region                   = "europe-west1"
    private_ip_google_access = false
    ip_cidr_range            = "10.0.0.0/20"
  }]
  ```

  The object accepts the following attributes:

  - [**`name`**](#attr-name-1): *(**Required** `string`)*<a name="attr-name-1"></a>

    The name of the resource, provided by the client when initially creating the resource.

  - [**`region`**](#attr-region-1): *(Optional `string`)*<a name="attr-region-1"></a>

    The GCP region for this subnetwork.

  - [**`private_ip_google_access`**](#attr-private_ip_google_access-1): *(Optional `bool`)*<a name="attr-private_ip_google_access-1"></a>

    When enabled, VMs in this subnetwork without external IP addresses can access Google APIs and services by using Private Google Access.

    Default is `true`.

  - [**`ip_cidr_range`**](#attr-ip_cidr_range-1): *(**Required** `string`)*<a name="attr-ip_cidr_range-1"></a>

    The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported.

  - [**`secondary_ip_ranges`**](#attr-secondary_ip_ranges-1): *(Optional `list(secondary_ip_range)`)*<a name="attr-secondary_ip_ranges-1"></a>

    An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.

    Example:

    ```hcl
    secondary_ip_range {
      range_name = "tf-test-secondary-range-update1"
      ip_cidr_range        = "192.168.10.0/24"
    }
    ```

    The object accepts the following attributes:

    - [**`range_name`**](#attr-range_name-2): *(**Required** `string`)*<a name="attr-range_name-2"></a>

      The name associated with this subnetwork secondary range, used when adding an alias IP range to a VM instance. The name must be 1-63 characters long, and comply with RFC1035. The name must be unique within the subnetwork.

    - [**`ip_cidr_range`**](#attr-ip_cidr_range-2): *(**Required** `string`)*<a name="attr-ip_cidr_range-2"></a>

      The range of IP addresses belonging to this subnetwork secondary range. Provide this property when you create the subnetwork. Ranges must be unique and non-overlapping with all primary and secondary IP ranges within a network. Only `IPv4` is supported.

  - [**`log_config`**](#attr-log_config-1): *(Optional `object(log_config)`)*<a name="attr-log_config-1"></a>

    An array of configurations for secondary IP ranges for VM instances contained in this subnetwork. The primary IP of such VM must belong to the primary ipCidrRange of the subnetwork. The alias IPs may belong to either primary or secondary ranges.

    Example:

    ```hcl
    log_config {
      aggregation_interval = "INTERVAL_10_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
      metadata_fields      = "CUSTOM_METADATA"
      filter_expr          = true
    }
    ```

    The object accepts the following attributes:

    - [**`aggregation_interval`**](#attr-aggregation_interval-2): *(Optional `string`)*<a name="attr-aggregation_interval-2"></a>

      Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Default is an interval of `5 seconds` per connection. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.

    - [**`flow_sampling`**](#attr-flow_sampling-2): *(Optional `number`)*<a name="attr-flow_sampling-2"></a>

      Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported.

    - [**`metadata`**](#attr-metadata-2): *(Optional `string`)*<a name="attr-metadata-2"></a>

      Can only be specified if VPC flow logging for this subnetwork is `enabled`. Configures whether metadata fields should be added to the reported VPC flow logs. Possible values are `EXCLUDE_ALL_METADATA`, `INCLUDE_ALL_METADATA`, and `CUSTOM_METADATA`.

    - [**`metadata_fields`**](#attr-metadata_fields-2): *(Optional `list(string)`)*<a name="attr-metadata_fields-2"></a>

      List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `"metadata"` is set to `CUSTOM_METADATA`.

    - [**`filter_expr`**](#attr-filter_expr-2): *(Optional `string`)*<a name="attr-filter_expr-2"></a>

      Export filter used to define which VPC flow logs should be logged, as as CEL expression. See https://cloud.google.com/vpc/docs/flow-logs#filtering for details on how to format this field.

- [**`default_log_config`**](#var-default_log_config): *(Optional `object(default_log_config)`)*<a name="var-default_log_config"></a>

  The default logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples.

  Default is `{"aggregation_interval":"INTERVAL_10_MIN","flow_sampling":0.5,"metadata":"INCLUDE_ALL_METADATA"}`.

  Example:

  ```hcl
  default_log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             ="INCLUDE_ALL_METADATA"
  }
  ```

  The object accepts the following attributes:

  - [**`aggregation_interval`**](#attr-aggregation_interval-1): *(Optional `string`)*<a name="attr-aggregation_interval-1"></a>

    Can only be specified if VPC flow logging for this subnetwork is enabled. Toggles the aggregation interval for collecting flow logs. Increasing the interval time will reduce the amount of generated flow logs for long lasting connections. Possible values are `INTERVAL_5_SEC`, `INTERVAL_30_SEC`, `INTERVAL_1_MIN`, `INTERVAL_5_MIN`, `INTERVAL_10_MIN`, and `INTERVAL_15_MIN`.

    Default is `"INTERVAL_10_MIN"`.

  - [**`flow_sampling`**](#attr-flow_sampling-1): *(Optional `number`)*<a name="attr-flow_sampling-1"></a>

    Can only be specified if VPC flow logging for this subnetwork is enabled. The value of the field must be in `[0, 1]`. Set the sampling rate of VPC flow logs within the subnetwork where `1.0` means all collected logs are reported and `0.0` means no logs are reported. The

    Default is `0.5`.

  - [**`metadata`**](#attr-metadata-1): *(Optional `string`)*<a name="attr-metadata-1"></a>

    Can only be specified if VPC flow logging for this subnetwork is enabled. Configures whether metadata fields should be added to the reported VPC flow logs.

    Default is `"INCLUDE_ALL_METADATA"`.

  - [**`metadata_fields`**](#attr-metadata_fields-1): *(Optional `list(string)`)*<a name="attr-metadata_fields-1"></a>

    List of metadata fields that should be added to reported logs. Can only be specified if VPC flow logs for this subnetwork is `enabled` and `metadata` is set to `CUSTOM_METADATA`.

    Default is `"CUSTOM_METADATA"`.

  - [**`filter_expr`**](#attr-filter_expr-1): *(Optional `string`)*<a name="attr-filter_expr-1"></a>

    Export filter used to define which VPC flow logs should be logged, as as CEL expression. See `https://cloud.google.com/vpc/docs/flow-logs#filtering` for details on how to format this field. The default value is `true`, which evaluates to include everything.

    Default is `"true"`.

#### Extended Resource Configuration

## Module Attributes Reference

The following attributes are exported in the outputs of the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`subnetworks`**

  The created subnet resources.

## External Documentation

### Google Documentation

- Configuring Private Google Access: <https://cloud.google.com/vpc/docs/configure-private-google-access>
- Using VPC networks: <https://cloud.google.com/vpc/docs/using-vpc>

### Terraform Google Provider Documentation

- <https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork#flow_sampling>

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in ` 0.0.z ` and ` 0.y.z ` version

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

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-network-subnet
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-google-network-subnet/workflows/Tests/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-google-network-subnet.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-google-network-subnet/actions
[releases-github]: https://github.com/mineiros-io/terraform-google-network-subnet/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[badge-tf-gcp]: https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform
[releases-google-provider]: https://github.com/terraform-providers/terraform-provider-google/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[gcp]: https://cloud.google.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-network-subnet/issues
[license]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-network-subnet/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-network-subnet/blob/main/CONTRIBUTING.md
