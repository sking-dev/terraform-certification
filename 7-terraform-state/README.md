# Objective 7: Implement and Maintain State

## Overview

Terraform follows the **desired state configuration** model.

_What Does That Mean?_

- The **configuration** describes the environment (infrastructure) to build
  - It uses **declarative code** to do this
- Terraform deploys the **desired state**

```plaintext
IMPORTANT: 

The desired state configuration model relies on mapping what currently exists in the live environment ("the real world") AND  what's expressed in the declarative code.

Terraform uses state (a JSON-formatted data structure) to *track this mapping*.
```

----

## 7A: Describe Default Local Backend

IF no explicit backend configuration is provided, Terraform defaults to using the **local file system** to store state.

A file called `terraform.tfstate` will be created in the root module (working directory)

You can change the location for this file by using the `-state=statefile` argument when running `terraform plan` or `terraform apply`.

```plaintext
NOTE: 

When using *Terraform workspaces*, the state file is stored in a subdirectory that relates to the workspace.

E.g. 

/working-directory/terraform-state.d/workspace-name/terraform.tfstate
```

----

## 7B: Outline State Locking

This is a very important concept!

To be able to work collaboratively, there has to be a way of preventing multiple simultaneous write operations from editing the state file.

_How Does Terraform Handle State Locking?_

Like this (more or less)

- The user submits an operation that edits state
  - Terraform checks, is the state (already) locked?
    - If it isn't locked, Terraform then locks the state before making the user's changes

----

### Options to Use on Terraform Commands

Available for the following commands.

- `terraform plan`
- `terraform apply`

```bash
# Set to "false" if you do *not* want to lock the state file.
# NOTE: This is not generally a good move!
-lock=false

# Set the duration for Terraform to wait to attain the lock.
# Some backends may take / need more time than others.
-lock-timeout=0s
```

----

The majority of state backends support locking BUT some do not!

- There are relatively few that do not, though, [according to this post](https://www.phillipsj.net/posts/discussion-of-terraform-backends/)
  - artifactory
  - swift
  - etcd

----

## 7C: Handle Backend State Authentication Methods

Some backends require **authentication** and **authorisation** to access state data.

Example One:

- Azure Storage Accounts
  - Access keys

Example Two:

- MySQL
  - Database credentials

----

_What's the Best Way to Work with Credentials?_

- It's **Not Good** to statically define them within a Terraform configuration
  - Refreshing credentials - highly advisable, on a regular basis - will require your code to be updated each time
  - Storing credentials in clear text on your local workstation / in source control is a **security risk**
- _Can I Use Terraform Variables?_
  - No!  
    - The backend is evaluated during `terraform init` so this happens **before** any variables are loaded / evaluated
- _So What's the Answer?_
  - You can use a **partial backend configuration** in the root module and provide the rest of the information at **runtime**
    - See [the section below](###the-backend-block) on the `backend` configuration block

----

## 7D: Describe Remote State Storage Mechanisms and Supported Standard Backends

Use a **remote state backend** to enable collaborative working.

Cf. the default local backend which can only really support a single user.

State data is stored in a **remote shared location**.

There are two classes of backends.

```plain text
1. Standard = includes state management *and* locking (IF supported by the chosen backend)

2. Enhanced =  includes remote operations in addition to the standard features (this class is available with Terraform Cloud and Terraform Enterprise)

----

NOTE: "Remote operations" are where Terraform operations like 'terraform plan' and 'terraform apply' are run on the remote service instead of locally.
```

State data in a remote backend is **not** written to disk on your local system.

It's loaded into memory (during Terraform operations) and then flushed after use.

This means that sensitive data is **not** stored on local disk.

This A Good Thing if the local system is lost or compromised.

```plaintext
Here's a list of all the *currently supported standard backends*.

- artifactory
- azurerm
- consul
- cos
- etcd
- etcdv3
- gcs
- http
- kubernetes
- manta
- oss
- pg
- s3
- swift

Source: https://www.terraform.io/docs/language/settings/backends/index.html
```

Remote state can (also) be used as a **data source**.

- Any outputs defined in a configuration can be accessed by using the state file as a data source

----

## 7E: Describe the Effect of Terraform Refresh on State

_What Does the Refresh Action Do?_

It examines the attributes of resources in the target environment and compares them to the values that are stored in state.

Refresh may need to update state tp reflect the target environment BUT it won't (cannot) alter the target infrastructure.

It's run automatically during a `terraform plan` OR a `terraform apply` IF these commands are run without a supplied execution plan.

You can trigger a refresh manually using the `terraform refresh` command.

----

## 7F: Describe Backend Block In Configuration and Best Practices for Partial Configurations

### The Backend Block

Backend configuration is defined within the `terraform` block of the root module.

- The `backend` block is a **nested block** (within the `terraform` block)

IMPORTANT: Only one backend can be specified per configuration.

```hcl
# Basic example.

# Source: https://www.terraform.io/docs/language/settings/backends/azurerm.html

terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

State **cannot** be stored in multiple backends simultaneously or split across different backends.

- If you need to do this, you should split out your configuration into interdependent configurations

----

### Best Practice for Partial Backend Configurations

Omit the settings that should be dynamically configured.

E.g. for the `azurerm` backend, this would be the values for `storage_account_name` and `access_key`.

These can then be supplied at **runtime**.

_How So?  Give Me Some Options!_

1. Interactively via the CLI when running `terraform init`
2. Using the `-backend-config` flag + a set of key/value pairs
3. Using the `-backend-config` flag + a path to a file holding the set of key/value pairs

Some backend arguments can be sourced from environment variables.

- _Allegedly, that is_
  - _I haven't been able to confirm this in the official documentation set_

After running `terraform init`, the values are stored in a local file in the `.terraform` directory so **do not** store this directory in source control!

----

## 7G: Understand Secret Management in State Files

State data is **not** encrypted by Terraform BUT it can (should) sit on an encrypted storage platform.

- Data encryption at rest **and** in transit
  - This will provide a level of protection for any sensitive data held in state

_What Kind of "Sensitive Data"?_

- Passwords
- API keys
- Access credentials

Remote state backend keeps state data off your local machine: it's written to **memory only** (and) on a **temporary basis**.

### Best Practice For Secret Management in State

**Do not** store any sensitive data in state!

Use a secrets management platform instead e.g. HashiCorp Vault or Azure Key Vault.

Your application should then (be configured to) retrieve the sensitive data it needs from this platform rather than from state.

----

## End of Objective 7
