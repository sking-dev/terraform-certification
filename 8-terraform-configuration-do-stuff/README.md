# Objective 8: Read, Generate, and Modify Configuration

## 8A: Demonstrate Use of Variables and Outputs

### Input Variables

Input variables are how values are submitted to a Terraform configuration.

- Option One
  - Supply the value at runtime
    - [See the section below](###how-to-submit-values-for-variables) for more details on this
- Option Two
  - Set the default value for the variable to use

NOTE: If no default value is set, Terraform will require one to be supplied at runtime.

### Input Variable Arguments

```hcl
variable "aws_region" {
    type        = string
    default     = "us-east-1"
    description = "This is the AWS region to use for this thing."
}
```

Supplying the data `type` enables Terraform to do some basic validation on the value being supplied.

NOTE: Terraform 0.13 onwards offers variable validation: you can add a `validation` block (into the `variable` block) that must evaluate to "true" / "false".

### How to Submit Values for Variables

_What Are the Available Options?_

1. Set environment variables using the prefix `TF_VAR` + your variable name
2. Use a `terraform.tfvars` / `terraform.tfvars.json` file in your configuration directory
3. Use a `filename.auto.tfvars` / `filename.auto.tfvars.json` file in your configuration directory
4. Use `-var-file` flag + path to a file holding your key/value pairs
5. Use `-var` flag + your key/value pairs
6. Type 'em in at the CLI when prompted by Terraform

NOTE: These options are listed in descending order of precedence AKA "the order of evaluation".  

A value could potentially be supplied in multiple places BUT a value from option 5 would take precedence over a value from option 1.

----

### Output Values

Outputs can be made available after a configuration has been deployed.

Outputs created by a root module are printed as part of the console output.

They can be queried using the `terraform output` command.

_Why Is This Useful?_

Here are two possible scenarios / use cases.

- Child modules
  - A child module can create variables + resources as required **as long as** it produces outputs that the **calling module** can use
    - Complex data types (e.g. an entire resource) **are** supported as outputs in Terraform 0.12 onwards
      - Prior to 0.12, outputs are limited to strings only so will require a supplementary function to transform the string output to a data type like `list` or `map`
- Terraform state data sources
  - Terraform state can be consumed as a data source by another configuration
    - The attributes available are determined by which outputs are exposed

### Output Block Syntax

```hcl
output "name_of_output" {
    value       = wibble.wobble
    description = "What is this for?"
    # Value not printed to CLI if "true"
    sensitive   = true / false
    depends_on  = [list of resources in explicit chain of dependence]
}
```

Outputs are rendered when `terraform apply` is run.

NOTE: If you subsequently change existing outputs or add any new outputs, you'll need to run `terraform apply` again (even if nothing else is changing in your configuration)

----

## 8B: Describe Secure Secret Injection Best Practice

A Golden Rule:

- Treat sensitive data with care
  - Consider carefully how you submit it to Terraform
    - E.g. application passwords / API tokens / usernames + passwords

### Recommendations from HashiCorp

- Do **not** store secrets in a `.tfvars` file
  - This file type is often stored (legitimately) in source control
  - Terraform does not (cannot) encrypt these files
- Avoid using the `-var` flag in the CLI
  - Your sensitive data will be stored in clear text in your command history!
- A **better way**...
  - Load sensitive data into **environment variables**
    - You don't (thereby) expose data to the CLI
    - Terraform doesn't show these variables in its output
- The **best way**...
  - Use a secrets lifecycle manager e.g. HashiCorp Vault / Azure Key Vault
    - Terraform can reference sensitive data via a **data source**
      - This means there's no local storage of values
- Remember...
  - Any sensitive data in a Terraform configuration will end up being stored in Terraform state
    - So store this state in a secure backend that supports encryption at rest
    - And **do not** store any local state files in source control!

----

## 8C: Understand the Use of Collection and Structural Types

### A Brief Overview of the Data Types Available in Terraform

There are three **primitive data types**.

```plaintext
1. string  = Unicode character sequence
2. number  = integer / decimal
3. boolean = true / false
```

Primitive types (can) have a **single** value.

Whereas...

Complex types (can) have **multiple** values.

There are two kinds of complex types.

```plaintext
1. Collection
2. Structural
```

----

### Collection Types

These are (the) most commonly encountered / used in Terraform.

There are three collection types.

```plaintext
1. list = sequential list of values identified by position in list (starts at 0)

2. map  = collection of values identified by unique key of type 'string'

3. set  = collection of unique values with no identifiers / ordering
```

NOTE: `set` is less common than `list` or `map`.

A Golden Rule:

- All values in a collection must be of the **same primitive type**

Terraform does offer the `any` primitive type: this is where Terraform tries to figure out the intended type **but** it's usually better to be prescriptive with input values, otherwise you may not get your desired structure.

```hcl
# Basic examples.

# Source: https://davemccollough.com/2020/10/10/learning-terraform-part-2-variables-expressions-and-functions/

# 'list' is a zero-based, comma-delimited list encapsulated in square brackets.

variable "vm_size" {
     type = list
     default = ["Standard_A1_v2", "Standard_A8_v2", "Standard_A8m_v2"]
}

# To access an item from a list, include index of (desired) value when referencing variable.

resource "azurerm_linux_virtual_machine" "linux_vm" {
     name = "linux_vm"
     resource_group_name = var.rg
     location = var.location
     size = var.vm_size[0]
}


# 'map' is a key/value collection.  Can be used to select specific values based on user defined key.
variable "vm_type" {
     type = map
     default = {
       compute = "Standard_F8s_v2"
       memory = "Standard_D12_v2"
       storage = "Standard_L32s_v2"
     }
}

# To reference an item from a mapped list, use the key to reference the correct item.

resource "azurerm_linux_virtual_machine" "linux_vm" {
     name = "linux_vm"
     resource_group_name = var.rg
     location = var.location
     size = var.vm_type["compute"]
}

----------------

# TODO: Add an example for 'set'.
```

### Structural Types

A more complex object where values **can** be of multiple types.

There are two structural types.

```plaintext
1. object = (similar to map) a set of key/value pairs where each value can be a different type

2. tuple  = (similar to list) an indexed set of values where each value can be a different type
```

_Crikey!  How Do I Decide Whether to Use Collection or Structural?_

The main criteria is, do you need to define **multiple types in your variable**?

If you do, you should use a **structural type**.

----

## 8D: Create and Differentiate Resource and Data Configuration

Most Terraform providers are composed of **data sources** and **resources**.

### Data Sources

- Sources of **information** that you can retrieve from a **provider**
  - E.g. you can retrieve an Azure VNet ID to (then) be able to deploy Azure VMs
- Most data sources require some configuration for them to be able to provide the information you're after
- They also assume that the `provider` is correctly configured
  - [See Objective 3](../3-terraform-basics/README.md##provider-installation) for more details on this

```hcl
# Basic examples.

# Data source for an existing resource group (created outside of this IaC)
data "azurerm_resource_group" "sking-dev-example-rg" {
  name = "rg-sking-dev-example"
}

# Data source for the remote state file for resources deployed by the "common" module for a given region.
data "terraform_remote_state" "common" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-${var.location}-tfstate"
    storage_account_name = "sa${var.location}tfstate"
    container_name       = "${var.location}commontfstate"
    key                  = "terraform.tfstate"
  }
}
```

### Resources

- These are the raison d'etre of Terraform (_oh la la!_)
  - To provision infrastructure, Terraform deploys resources from a provider
- Resources take **arguments** to define their configuration
  - Arguments can be required **or** optional
  - They can be simple key/value pairs **or** nested blocks
- Resources also make **attributes** available to reference in other sections of a configuration
  - Attributes are derived from the creation of a resource
    - Many are consequently unknown until the resource is fully created
- Variables and attributes of **other resources** can be used as arguments for a resource
  - IMPORTANT: The value type exposed by the attribute **must** match the type expected by the argument

### Looping and Multiple Instances

Terraform the offers the `count` and `for_each` **meta-arguments** to support the creation of multiple instances of a resource / data source / module.

_How Do I Decide When to Use Looping Constructs?_

Good question!  And the answer is, it's a bit "horses for courses".

```plaintext
For: 

Looping constructs make IaC more DRY (which is A Good Thing) 

Against: 

They can make IaC less human-readable => sometimes, specifying a bunch of instances manually will give more clarity / less ambiguity.
```

#### Count

- Takes a non-negative integer as value (0 is valid)
- The current iteration of a loop can be referenced using `count.index`
  - Use `count.index` to construct a value for an argument directly
    - E.g. `name = "webserver-${count.index}"`
- Or use it in a function or reference to another object in the configuration
  - TODO: Give an example here

_When Should I Get Busy with `count`?_

A typical scenario is, creating multiple instances of (very) similar objects that are differentiated by **minor details** e.g. IP address / instance name.

For more complex scenarios, you should use `for_each`.

#### For_each

- Takes a `set` or `map` of strings as value
  - NOTE: You may need to convert tuples to the `set` data type when submitting value to `for_each`
- Terraform creates instances of objects equivalent to the number of elements in a `set` **or** the number of keys in a `map`

_When Should I Use `for_each`?_

A typical scenario is, when you need to create objects with differences that are **not** easily expressed using an integer.

`for_each` allows more information to be submitted as part of the loop.

For example:

- Creating multiple objects based on a `list` or `map` of values
  - Create multiple storage accounts where the name of each storage account is derived from the `list` / `map` values.

TODO: Give a better (preferably real world) example.

----

## 8E: Use Resource Addressing and Resource Parameters to Connect Resources Together

The resources in a Terraform configuration will often be inter-related.  

For example, in Azure, you could have VNet --> Application Gateways --> Load Balancers --> other networking stuff.

### Resource Addressing

This is the way to reference the **attributes** of a resource (that is) within the Terraform configuration.

```plaintext
The syntax is, 'resource_type.resource_name.attribute'.

E.g. 

resource_group_name = azurerm_resource_group.rg-dev.name
```

Some arguments and attributes can be **complex value types** so you may need special syntax to extract the desired value.

E.g. where an attributes returns a set (rather than a list or a map) you **cannot** refer to a specific object by index or key.

_Uh Oh!  How Should I Handle this Scenario?_

Use a `for` expression to iterate over the set and select the required ket from each object.

```plaintext
E.g. 

[for subnet in azurerm_virtual_network.vnet.subnet : subnet ["name"]]
```

----

## 8F: Use Terraform Built-in Functions to Write Configuration

The **format** of data returned by data sources / resources may not be suitable for passing to another resource.

Functions can be used to:

- Transform outputs from a module
- To combine variables
- To read in file data

_How Do I Invoke a Function?_

A function takes arguments of specific types.

It returns value of a specific type.

```plaintext
Basic format = function (arguments,...)

E.g.

max (number,number,...) = returns number that is largest value of given set

lower (string)          = returns a string in all lowercase

keys (map)              = returns a list of the keys in the given map


Functions can be combined.

E.g.

abs(min(1,-10,5))       = finds the smallest value *then* returns the absolute value
```

_How Do I Test a Function?_

You can test the output of a function by using the `terraform console` command.

- Run the command (whilst) in a working directory
  - The current state is loaded
    - You gain access to state data to test functions / other interpolations

Using `terraform console` with state enables much more meaningful testing.

The console does **not** alter the state.

After testing and validating your functions, you can incorporate them into your Terraform configuration.

----

## 8G: Configure Resources Using Dynamic Block

Dynamic blocks can be used inside resources / data sources / providers / provisioners.

A `dynamic` block expression => one or more nested blocks.

Values are retrieved from variables.

TODO: Give (and spell) out the example from the study guide (p.93 of PDF)

A Word to the Wise:

- Dynamic blocks can be a double-edged sword (in a similar way to looping constructs)
  - Pros: scalable / dynamic
    - Versus manually creating nested blocks
  - Cons: reduces (human) readability of the Terraform configuration

----

## 8H: Describe Built-in Dependency Management (Order of Execution Based)

Terraform analyses a configuration --> it creates a **resource graph** --> this lists out all the **resources** and their **dependencies**.

This means that Terraform can create the resources in the correct order AND can also create resources in parallel IF they are not interdependent.

_What if Terraform isn't Doing what I Need / Expect?_

You can instruct Terraform about **explicit dependencies** using the `depends_on` meta-argument.

A Golden Rule:

- Use `depends_on` sparingly
  - Terraform is generally best left alone to manage the correct order of resource creation.

If you find yourself needing to intervene with a cheeky `depends_on`, it could be a sign that you need to rethink your architecture!

----

## End of Objective 8
