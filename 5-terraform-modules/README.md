# Objective 5: Interact with Terraform Modules

## Overview

_What's a "Module" in Terraform Speak?_

It's a **reusable configuration** that defines the following components.

- Inputs
- Resources
- Outputs

NOTE: Each of these components is optional rather than mandatory.

Any directory containing Terraform files can effectively be classed as a module.

But - when you're **using modules explicitly** - there are **two types** to consider.

| Module Type  | What Is It For?                                                                                                          |
| ------------ | ------------------------------------------------------------------------------------------------------------------------ |
| Root module  | The principal configuration e.g. the main configuration for an environment / subscription.                               |
| Child module | Invoked by the root module to handle a specific configuration task.  A child module **can** invoke another child module. |

The module that's doing the invoking can be referred to as, the **calling module**.

The module being invoked can be referred to as, the **child module**.

----

## 5A: Contrast Module Source Options

Basically, Terraform needs to know, where are your module's files stored?  

To put it another way, what's the source of the module?

There are a number of options:

- Local paths
  - Your local file system
- Terraform Registry
  - <https://registry.terraform.io/>
    - This includes modules maintained and verified by third party vendors
- GitHub
- Bitbucket
- Generic Git repo
- Generic Mercurial repo
- HTTP URLs
- S3 buckets
- GCS buckets

For remote sources, Terraform copies the the module's files to a local `.terraform` directory during a `terraform init` operation.

**Alternatively** you can use `terraform get` to download the files without invoking the initialisation routine.

_What About Rolling Your Own Modules?_

Terraform best practice:

- Store your modules **locally** IF they're tightly coupled to your configuration
- ELSE store them in a **shared location**
  - This location can be public **or** private
    - Your modules can then be **reused** across projects / teams

----

## 5B: Interact With Module Inputs and Outputs

### Input Variables

These act as **parameters** for a module.

- They enable customisation **without** modifying the module's code
- The module can be **shared** between different configurations

_Where Are They Defined?_

Variables in a root module:

- You set the values via CLI options OR environment variables

Variables in a child module:

- The calling module passes the values in the `module` block

```hcl
# Basic examples.

# Source: https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d

# Define the variable in the root module.
# E.g. in modules/services/webserver-cluster/variables.tf

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

# Reference the variable from another file in the root module.
# E.g. from within modules/services/webserver-cluster/main.tf

resource "aws_security_group" "elb" {
  name = "${var.cluster_name}-elb"  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Set the variable value in a child module.
# E.g. from stage/services/webserver-cluster/main.tf
# In this example, the value is being set to reflect the target environment (staging)

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"  cluster_name = "webservers-stage"
}
```

----

### Output Values

These expose attributes of local resources for external consumption.

Example One:

- Child module --> outputs --> expose subset of resource attributes to **the calling module**

```hcl
# Basic example.

# Source: https://www.devopsschool.com/blog/how-to-use-one-modules-variable-in-another-module-in-terraform/

# Define an output in "kafka" module.

output "instance_ids" {
  value = ["${aws_instance.kafka.*.id}"]
}

# Access that output from "cloudwatch" module by calling "kafka" module.

instances = ["${module.kafka.instance_ids}"]
```

Example Two:

- Root module --> outputs --> print values **to the CLI** after the `terraform apply` operation

Example Three:

- Remote state --> root module --> outputs --> accessible to other configurations via the `terraform-remote-state` data source.

```hcl
# Basic example.

# Define output in root module ("common")

output "rg_name" {
  value = var.rg_name
}

# Define data source in child module.

data "terraform_remote_state" "common" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-${var.location}-tfstate"
    storage_account_name = "sa${var.location}tfstate"
    container_name       = "${var.location}commontfstate"
    key                  = "terraform.tfstate"
  }
}

# Access 'rg_name' output in child module.

resource "azurerm_route_table" "sking_dev_example_route_table" {
  name                          = "example-${var.location}-external-route-table"
  location                      = var.location
  resource_group_name           = data.terraform_remote_state.common.outputs.rg_name
  disable_bgp_route_propagation = true
  tags                          = local.default_tags

  route {
    name                   = "BranchOffice"
    address_prefix         = "192.168.200.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.20.0.20"
  }
}
```

----

## 5C: Describe Variable Scope Within Modules / Child Modules

A local value defined in a module is **only** available in the context of that module.

Calling modules / child modules can only access it if the variable exposed as an **output value**.

Child modules cannot access a variable defined in a calling module unless it's **explicitly** passed as an **input**.

----

## 5D: Discover Modules From the Public Terraform Module Registry

The best example of a public registry is [Terraform Registry](https://registry.terraform.io/) .

This offers official modules for various public cloud providers.

These are **open-source** - the code is on **GitHub** - and there's no charge to use them.

Terraform best practice:

- **Specify the version** to use in your module configuration block to avoid the possibility of breaking changes arising from (the use of) a different version

----

## 5E: Defining Module Version

Terraform best practice:

- **Constraining the version** is recommended especially for modules sourced from a public module registry (see also above)

```hcl
module "pickle" {
  source  = "cheese-modules/pickle/azure"
  version = "2.20.0"
}
```

The following arguments can be used.

NOTE: These syntax options are similar to how the `provider` version is specified.

```plaintext
>= 2.20.0
<= 2.20.0
~> 2.20.0
>= 2.0.0, <= 2.20.0
```

IMPORTANT:

- Version constraint only works if **version numbers** are available for the module
- Locally defined modules do **not** support version numbers!
  - It requires a module **registry** e.g. public **or** private in Terraform Cloud (if you want to keep it internal to your organisation)

----

## End of Objective 5
