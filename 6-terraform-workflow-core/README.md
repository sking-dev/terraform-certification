# Objective 6: Navigate Terraform Workflow

## 6A: Describe Terraform Workflow ( Write - Plan - Create )

Behold the core workflow in Terraform!

```plaintext
Step:

1. Create a configuration                    = Write

2. Preview changes                           = Plan

3. Commit changes to target environment      = Create (AKA "Apply")

----

4. Remove deployment when no longer required = Destroy (AKA "Delete")
```

NOTE: Steps 1 through 3 tend to occur more frequently than step 4.

----

## 6B: Initialise a Terraform Working Directory (terraform init)

```bash
terraform init

# Arguments for this command.
-backend-config

-input

# Set directory for required plugins - this prevents automatic installation - useful for regulated / highly secure environments.
-plugin-dir

# Set to "true" to force update to newest version of module / plugin allowed by constraints + update the lock file ('.terraform.lock.hcl' in version 0.14 onwards)
-upgrade

# If not specified, Terraform will initialise the current working directory.
[DIR]
```

A Golden Rule:

- `terraform init` is the first command you can - and must - run on a Terraform configuration

_What Does It Do?_

- Prepares state storage
  - Local OR remote backend
  - Verifies access
    - But does **not** generate (write) state
- Retrieves modules
  - Any module used by the configuration is placed in the configuration directory
- Retrieves plugins
  - Any direct **or** indirect reference(s) to provider(s) and provisioner(s) causes the plugin to be retrieved

This command can be rerun safely at any time BUT it only **needs** to be run again in the following scenarios.

- A **new instance is added** of any of the following
  - Module
  - Provider
  - Provisioner
- The **required version is updated** for any of the following
  - Module
  - Provider
  - Provisioner
- The **configured backend is changed**

----

## 6C: Validate a Terraform Configuration (terraform validate)

```bash
terraform validate
```

This command provides a **syntax check** that returns:

- Warnings
  - E.g. for deprecated features or syntax
- Errors
  - For invalid syntax

It does **not** check the formatting.
  
- You should use `terraform fmt` for this

It can be run explicitly.

OR implicitly.

- It gets run automatically during `terraform plan` and `terraform apply` operations

You must run `terraform init` before attempting to use `terraform validate`.

_Why Is That, Then?_

The validation checks syntax for modules / providers / provisioners, so Terraform must have access to these plugins to be able to interact with their syntax e.g. to check which arguments and values are valid / invalid.

NOTE: Be aware that `terraform validate` may pass invalid values if they conform to the 'string' type - "invalid" as in, not supported by the cloud provider resources.

It doesn't appear to be within in the scope of the exam, but you can use the `validation` block in Terraform 0.13 onwards to gain more control over input values.

```hcl
# Basic example.

# Source: https://www.hashicorp.com/blog/custom-variable-validation-in-terraform-0-13

# Define a condition for the variable 'ami_id' which requires the id to begin with the string "ami".

variable "ami_id" {
      type = string

      validation {
        condition = (
          length(var.ami_id) > 4 &&
          substr(var.ami_id, 0, 4) == "ami-"
        )
        error_message = "The ami_id value must start with \"ami-\"."
      }
    }
```

----

## 6D: Generate and Review an Execution Plan for Terraform (terraform plan)

```bash
terraform plan

# Arguments for this command.

# Ask for input for variables if not directly set.  
# Set to "false" for automation scenarios so it won't prompt for any input.
-input=true

# Specify destination file to save the execution plan so it can be used by a 'terraform apply' operation.
-out=path

# Refresh the state (defaults to "true")
-refresh=false 

# Set value for variable (can be used multiple times)
-var 'wibble=wobble'

# Specify a file that holds your variables (key/value pairs)
-var-file=wibble

# If not specified, Terraform will operate on the current working directory.
[DIR]

```

This commands includes syntax validation.

- Equivalent to running `terraform validate`

It refreshes the state (checks the live environment)

It compares the state against your configuration (the proposed changes)

_When Should I Use It?_

- As a check before merging code (source control)
- As a check to validate the current configuration
- To prepare to execute changes to the live environment

----

## 6E: Execute Changes to Infrastructure With Terraform (terraform apply)

```bash
terraform apply

# Arguments for this command.
# NOTE: If not specified, syntax follows that of 'terraform plan'.

# Skip approval and proceed with changes.
-auto-approve

#  Path to backup the existing state file before modifying.
-backup=path

# Ask for input for variables if not directly set.
-input=true

-refresh

-var

-var-file
```

This command prepares an execution plan (equivalent to `terraform plan`) OR it references a plan (file) that was created by `terraform plan`.

The execution plan is presented to the user for **approval**.

The changes are applied after approval is received:

- This aligns the live environment with the desired state as expressed by the configuration

NOTE: If a saved execution plan is referenced, an execution plan is **not** generated and approval is **not** required i.e. changes in the plan file are applied toot sweet!

----

## 6E: Destroy Terraform Managed Infrastructure (terraform destroy)

```bash
terraform destroy

# Arguments for this command.

# Skip approval and proceed with changes.
-auto-approve

# Specify the target + dependencies to destroy (can be used multiple times)
-target
```

_When Should I Use This Command?_

This command is useful in the following scenarios.

- To clean up development resources once a project has been delivered
- To remove a testing environment used temporarily by CI/CD pipeline

### To See What terraform destroy Will Do

```bash
terraform plan -destroy
```

### Approach With Caution

WARNING: `terraform destroy` deletes resources that are under Terraform control and its actions **cannot** be undone!

However, it will prompt for **confirmation** before going ahead - unless the `-auto-approve` argument is used.

----

## End of Objective 6
