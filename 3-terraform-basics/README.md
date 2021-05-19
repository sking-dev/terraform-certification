# Objective 3: Understand Terraform Basics

## Terraform Installation

Terraform is made available as a single executable binary.  

It's supported by a variety of operating systems: Linux, macOS, Oracle Solaris, Unix, and Windows.

### How to Install Terraform On a Windows System

For the purposes of this exam, there are two possible ways to do this.

#### Method One

- Download the .ZIP file for the binary from [the HashiCorp Web site](https://www.terraform.io/downloads.html)
- Extract the `terraform.exe` file to a folder of your choice e.g. `D:\Software\Terraform`
- Set the path to the executable via Environment Variables > System variables
  - See this [helpful Stack Overflow question](https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows) for more details

You can test your installation via the CLI.

```plaintext
Enter this command:

terraform version


It should return (something like) this:

Terraform v0.15.3
on windows_amd64
```

#### Method Two

You can use the Chocolatey package manager.

NOTE: You'll need to [install Chocolatey](https://chocolatey.org/install) first.

```chocolatey
choco install terraform
```

NOTE: This package is **not** maintained by HashiCorp, so it may not provide the latest and greatest version.

You can install a specific version, should you need to.

```chocolatey
choco install terraform --version=0.13.5
```

----

## Provider Installation

A provider is an executable plugin.

It interacts with the API of the relevant service e.g. AWS or Azure.

It can be **explicitly defined** within the configuration OR **implicitly** via (the presence of) a resource / data source that uses the provider.

### The provider Block

See the accompanying [sample Terraform configuration](provider.tf) to get an idea of what this looks like.

As you'll see, it can include **authentication** information.

NOTE: The `version` argument in the `provider` block is now deprecated --> use a `required_providers` block instead.

### The required_providers Block

See the accompanying [sample Terraform configuration](provider.tf) to get an idea of what this looks like.

The `required_providers` block can be set in the root module and inherited by any child modules => easier to update provider version (in a single place versus in multiple .TF files)

_Hang On..!  What Are "Root" and "Child" Modules?_

Fear not!  All will be revealed in [Objective 5](../5-terraform-modules/README.md) .

## Provider Versioning

The version number syntax is as follows.

|Argument  | What It Means                                     |
|----------|---------------------------------------------------|
|>= 1.40.0 | Greater than OR equal to                          |
|<= 1.40.0 | Less than OR equal to                             |
|~> 1.40.0 | Any (minor) version within 1.40.x (release) range |
|>= 1.20, <= 1.41 | Any version between 1.20 and 1.41          |

_What's the Best Way to Handle the Provider Version?_

It's considered best practice to explicitly constrain the provider version to ensure that the expected / required version is used for a given configuration.

This is also known as "locking the provider version".

```plaintext
Like this:

version = "=2.59.0"
```

If you choose any of the other, more "liberal" syntax options, there could be a risk of breaking changes being introduced from team members / pipelines using an earlier or later version.

### Lock File

As of Terraform 0.14, we have the `.terraform.lock.hcl` file.

This records the versions of all the providers used by the configuration.

It **can** be checked into source control => a consistent experience for any user of the configuration.

To update the lock file versions e.g. when you need to change the configuration-wide constrained versions --> `terraform init -upgrade`.

----

## What the Flip is Plugin-based Architecture?

The Terraform binary does **not** include code to interact with providers and provisioners!

_Why Not?_

It's to keep the binary lean AND to keep provider / provisioner updates independent of the core application.

It also has some extra benefits.

- Reduces the potential attack surface
- Enables easier debugging of core code
- Delineates core functionality
  - AKA "What is Terraform responsible for?"

----

## Multiple Providers

A Terraform configuration supports:

- Multiple **different** providers
- OR
- Multiple instances of the **same** provider

For example, in the second scenario, your configuration might deploy to multiple Azure subscriptions.

- How does this work?
  - You can leverage the `alias` argument

See the accompanying [sample Terraform configuration](provider-multiple.tf) to get an idea of what this looks like.

----

## How Terraform Finds and Fetches Providers

The way that Terraform finds and fetches providers has changed over time.

### Prior to Version 0.13

There were two categories of Terraform provider.

- HashiCorp distributed
  - Hosted by HashiCorp
  - Available for download automatically during Terraform initialization
- Independent third party
  - Placed in a local plug-ins directory located at:
    - `%APPDATA%\terraform.d\plugins` for Windows
    - `∼/.terraform.d/plugins` for other operating systems

### Version 0.13 Onwards

Providers can be automatically downloaded from either a **public** OR **private** repository.

- The official public repository for Terraform is located at <https://registry.terraform.io/>
- Includes **three types** of providers:
  - Official
    - Owned and maintained by HashiCorp
  - Verified
    - Maintained by others vendors
    - Have gone through the partner provider process
  - Community
    - Published and maintained by
individuals
    - **Not** officially supported

TODO: Expand on this section, as there's a bit more to it.

----

## When and How to Use Provisioners

IMPORTANT: The use of provisioners is **not** recommended by HashiCorp!

But - if you absolutely have to - you can use `remote-exec` to run a script on a remote machine via WinRM / SSH OR `local-exec` to run a script on your local machine.

TODO: Expand on this section e.g. give an example of each type of provisioner.

----

## End of Objective 3
