# Objective 5: Interact with Terraform Modules

## Overview

_What's a "Module" in Terraform Speak?_

It's a **reusable configuration** that defines:

- Inputs
- Resources
- Outputs

NOTE: Each of these components is optional rather than mandatory.

Any directory containing Terraform files can effectively be classed as a module.

But when you're using modules **explicitly**, there are two types to consider.

|Module Type  | What's It For?                                  |
|-------------|-------------------------------------------------|
|Root module  | The principal configuration e.g. the main configuration for an environment / subscription.                |
|Child module | It's invoked by the root module to handle a specific configuration task.  NOTE: A child module can invoke another child module.                                                         |
|N/A          | TODO: Make this table look nicer!                                                          |

The module that's doing the invoking can be referred to as, the **calling module**.

The module being invoked can be referred to as, the **child module**.

----

## Module Source Options

Basically, Terraform needs to know, where are your module's files stored?  

AKA "What's the source of the module?"

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

- Store your modules locally **if** they're tightly coupled to your configuration
- **Else** store them in a **shared location**
  - This location can be public **or** private
  - Your modules can then be **reused** across projects / teams.

----

## Module Inputs and Outputs

### Input Variables

These **act as parameters** for a module:

- They enable customisation **without** modifying the module's code 
- PLUS the module can be **shared** between different configurations

_Where Are They Defined?_

Variables in a root module:

- You set values via CLI options **or** environment variables

Variables in a child module:

- The calling module passes the values in the `module` block

TODO: Provide examples of each and explain the syntax.  Also the distinction between "simple" and "complex" types.

----

### Output Values

These expose attributes of local resources for external consumption.

Example One:

- Child module --> outputs --> expose subset of resource attributes to **the calling module**

Example Two:

- Root module --> outputs --> print values **to the CLI** after the `terraform apply` operation

Example Three:

- Remote state --> root module --> outputs --> accessible to other configurations via the `terraform-remote-state` data source.

TODO: Expand on these examples and provide syntax.

----

## Variable Scope Within Modules

A local value defined in a module is **only** available in the context of that module.

Calling modules / child modules can only access it if the variable exposed as an **output value**.

Child modules cannot access a variable defined in a calling module unless it's **explicitly** passed as an **input**.

----

## The Public Module Registry

The best example of a public registry is [Terraform Registry](https://registry.terraform.io/) .

This offers official modules for various public cloud providers.

These are open-source (the code is on GitHub) and there's no charge to use them.

Terraform best practice:

- Specify the version to use in your module configuration block to avoid the possibility of breaking changes arising from (the use of) a different version

----

## Defining Module Version

Terraform best practice:

- Constraining the version is recommended especially for modules sourced from a public module registry (see also above)

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
