# Objective 4: Use the Terraform CLI (Outside of Core Workflow)

## Understand the Help Command (terraform help)

_This command is not included in HashiCorp's Study Guide or Exam review, but it is covered in the Leanpub exam preparation guide._

Terraform has a **built-in help system** which is accessed via the **CLI**.

```powershell
# To see all of Terraform’s top-level commands.
terraform -help


# Append `-help` to the particular command you're interested in.
terraform plan -help
```

----

## 4A: Choose When to Use terraform fmt to Format Code

```powershell
terraform fmt -help

Usage: terraform [global options] fmt [options] [DIR]

        Rewrites all Terraform configuration files to a canonical format. 
        Both configuration files (.tf) and variables files (.tfvars) are updated.
        JSON files (.tf.json or .tfvars.json) are not modified.

        If DIR is not specified then the current working directory will be used.
        If DIR is "-" then content will be read from STDIN. The given content must
        be in the Terraform language native syntax; JSON is not supported.

Options:

  -list=false    Don't list files whose formatting differs
                 (always disabled if using STDIN)

  -write=false   Don't write to source files
                 (always disabled if using STDIN or -check)

  -diff          Display diffs of formatting changes

  -check         Check if the input is formatted. Exit status will be 0 if all
                 input is properly formatted and non-zero otherwise.

  -no-color      If specified, output won't contain any color.

  -recursive     Also process files in subdirectories. By default, only the
                 given directory (or current directory) is processed.
```

_The `terraform fmt` command is used to rewrite Terraform configuration files [.TF and .TFVARS] to a canonical format and style. This command applies a subset of the Terraform language style conventions, along with other minor adjustments for readability._

Source: <https://www.terraform.io/docs/cli/commands/fmt.html>

NOTE: I'm not convinced that "canonical format" is the right term to use here; to put it another way, this command rewrites your configuration so it adheres to HashiCorp's style guide / coding conventions for Terraform.

_Why Is This Command Useful?_

**Consistent formatting** adds value to shared / collaborative code!

Here's an example of how `terraform fmt` might be used in a build (CI) pipeline to be run by Azure DevOps Services.

```yaml
    # Static analysis part one: style convention check using 'terraform fmt'.
    - task: TerraformCLI@0
      displayName: 'Run terraform fmt'
      inputs:
        command: 'fmt'
        # TODO: Replace explicit folder path component with variable, but need to establish the syntax for this.
        workingDirectory: '$(System.DefaultWorkingDirectory)/azure/terraform/common/uksouth'
        commandOptions: '-check=true -write=false -diff=true'
```

----

## 4B: Choose When to Use terraform taint to Taint Terraform Resources

```powershell
terraform taint

terraform untaint
```

Use this command to to mark a resource as "tainted" in your state file.

_Why Do That?_

_The `terraform taint` command informs Terraform that a particular object has become degraded or damaged. Terraform represents this by marking the object as "tainted" in the Terraform state, in which case Terraform will propose to replace it in the next plan you create._

Source: <https://www.terraform.io/docs/cli/commands/taint.html>

To put it another way, the tainted resource will be destroyed and then (re)created on the next run of `terraform apply`.

----

## 4C: Choose When to Use terraform import to Import Existing Infrastructure Into Your Terraform State

```powershell
terraform import
```

Use this command to import existing infrastructure into Terraform configurations.

### Doing It the Terraform Way

This is currently a manual process.

Say you have some Azure resources to bring under Terraform control.

First you have to **create Terraform code** that corresponds to the deployed resources.

Then you use `terraform import...` to match the **resource IDs** (in Azure) of the live resources to the resource blocks you've defined in your IaC (as recorded in your Terraform **state**)

You have to do this **one resource at a time**.

Then you run `terraform plan` to ensure that you have a 100% match between the live resources and your Terraform state.

You should see "No changes" if your import has been fully successful.

Finally (_phew!_) you use `terraform state...` to move the local state you've created to remote state as per Terraform best practice.

TODO: The above procedure has been somewhat brutally summarised; it should be fleshed out at a later date.

### Going Third Party

NOTE: This is **not** within the scope of the exam, but it's worth knowing about.

As an alternative to the native `terraform import` command, you can use a third party Terraform generator.

E.g. [Terraformer](https://github.com/GoogleCloudPlatform/terraformer) : _A CLI tool that generates tf / json and tfstate files based on existing infrastructure (reverse Terraform)_

This should result in a more automatic procedure, but there will probably be some rough edges that will require a degree of manual input.

TODO: Try this out and report back!

----

## 4D: Choose When to Use terraform workspace to Create Workspaces

```powershell
terraform workspace

... new
... select
... list
... show
... delete
```

_What's a "Workspace"?_

An independently managed state file that shares a common configuration.

_Why Do That?_

- Workspaces support the use of a configuration in multiple environments
  - E.g. DEV --> TEST --> STAGING --> PROD
- This gives **consistency of infrastructure** across environments.

NOTE: See [Objective 9 for more on workspaces](../9-terraform-enterprise/README.md###workspaces) including how they differ in open-source Terraform versus Terraform Enterprise.

----

## 4E: Choose When to Use terraform state to View Terraform State

```powershell
terraform state

... list
... mv
... pull
... push
... rm
... show
```

Use this command to edit your state.  

IMPORTANT: Don't edit (the) state files directly!

----

## 4F: Choose When to Enable Verbose Logging and What the Outcome /Value Is

_Terraform has detailed logs which can be enabled by setting the TF_LOG environment variable to any value. This will cause detailed logs to appear on stderr._

Source: <https://www.terraform.io/docs/internals/debugging.html>

```plaintext
For detailed logs, there are five log levels.

In descending order of verbosity:

TRACE
DEBUG
INFO
WARN
ERROR
```

_Why Do That?_

You may need extra details above and beyond the standard error output (stderr) to assist with your troubleshooting.

_How Do That?_

Set the environment variable `TF_LOG`.

Can also set `TF_LOG_PATH` to a specific file location.

_But What Does That Mean?_

The HashiCorp documentation (see above) doesn't spell out _how_ to enable verbose logging via the CLI.

To be honest, it's been a while since I had to use this "in anger" so I refreshed my memory courtesy of [this helpful blog post](https://www.codewithadam.com/how-to-configure-terraform-logging/) - I've filleted out the CLI commands (see below) but it's worth reading the full post for (more) context.

```powershell
# PowerShell.
# Set desired logging level.
> $env:TF_LOG="TRACE"
# Set path for the resulting log file.
> $env:TF_LOG_PATH="./logs/terraform.log"
```

```bash
# Bash equivalent.
$ export TF_LOG="TRACE"
$ export TF_LOG_PATH="./logs/terraform.log"
```

NOTE: There's also the `crash.log` file which is generated if the Terraform executable crashes.  This file is intended for use by Terraform Support.

----

## End of Objective 4
