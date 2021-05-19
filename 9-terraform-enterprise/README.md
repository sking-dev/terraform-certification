# Objective 9: Understand Terraform Enterprise Capabilities

_What Is "Terraform Enterprise"?_

Terraform Enterprise (TFE) is an **on-premises** distribution of Terraform Cloud  (TFC)

AKA "a **private instance** of Terraform Cloud".

No resource limits!

Plus additional **enterprise-grade features** e.g. audit logging / SAML SSO.

_And What About Terraform Cloud?_

TFC is the cloud-hosted version of TFE (_well, I never!_)

NOTE: For most intents and purposes - e.g. this certification exam - you can treat TFE and TFC as (being) **the same product**.

----

## The Benefits of Sentinel, Registry, and Workspaces

### Sentinel

- A language and framework for **policy**
  - "Policy" = the circumstances under which a certain behaviour is allowed
- An enterprise-only feature of the following HashiCorp products
  - Terraform (_hurrah!_)
  - Consul
  - Nomad
  - Vault
- Enforces policy on Terraform configurations / states / plans
- Integrates with Terraform
  - Runs after `terraform plan` and (thereby) before `terraform apply`
    - This gives the polices access to the created plan PLUS the state at the time of the plan PLUS the configuration at the time of the plan
- Sentinel Policies
  - Rules enforced on Terraform runs
    - Validates that the plan + resulting resources conform to company policy
  - A policy is added to an organisation and subsequently enforced on all runs
  - If a plan does **not** follow Sentinel Policy, resource creation is prevented!

### Registry

- TFE offers the **private registry** feature
  - As opposed to [the public registry covered in Objective 5](../5-terraform-modules/README.md)
- Share modules and provider plugins privately within an organisation
- Also offers support for:
  - Versioning
  - Configuration design
  - Search functionality
- NOTE: TFE is (even) more private than TFC as it's hosted on the organisations own hardware (versus on public Internet)

### Workspaces

- NOTE: This is **not** the same as the [workspaces covered in Objective 4](../4-terraform-cli-but-not-core-workflow/README.md)
- In TFE, workspaces are how TFE / TFC **organises** infrastructure configuration
  - Including the configuration / variables / state / logs
- See the next section for more details!

----

## OSS Workspaces Versus TFE Workspaces

_What Are We Comparing Here?_

```plaintext
"OSS" = free open-source CLI to run on a local system and / or in a pipeline

"TFE" = on-premises Terraform for Teams (formerly known as, Private Terraform Enterprise)

"TFC" = hosted Terraform for Teams (formerly known as, Terraform Enterprise)
```

### Workspaces in OSS

- Use the same configuration for multiple environments **but** have a separate state file per environment
- Only deal with **state management**
  - No help with other aspects of a configuration e.g. the values submitted for variables OR logs of previous actions
- To submit different values for each workspace --> (you have to) factor this into the logic of your pipeline / script

### Workspaces in TFE

- Offer state management **plus** extra features / capabilities!
  - Integrate with Version Control System (VCS) e.g. GitHub / GitLab
    - The workspace construct gets its configuration from source control (repo)
- A TFE workspace contains the following goodies
  - Terraform configuration
    - Usually from a repo **or** can ber uploaded directly
  - Values for variables used by the configuration
  - Secrets and credentials
    - Stored as sensitive variables
  - Persistent stored state (for Terraform-managed resources)
  - Historical state and run logs

_Why Is This Better Than Its OSS Equivalent?_

It has two main "selling points".

1. The ability to **manage values** for variables / credentials / secrets
2. The ability to **automate updates** using webhooks into your VCS of choice

----

## Summarise Features of TFC / TFE

Here's a handy reference list of the features available in TFC!

- **Workspaces**
  - As per [the section above](###workspaces)
- **VCS integration**
  - Automate runs of Terraform
  - Planning runs (via Pull Requests)
  - Publish modules to a private registry
- **Private Module Registry**
  - Refer back to [the section above](##the-benefits-of-sentinel-registry-and-workspaces)
- Remote operations
  - Managed disposable VMs to run terraform commands remotely
  - PLUS advanced features like Sentinel policy enforcement and cost estimation
- Organisations
  - Access control for users / groups / organisations
- **Sentinel**
  - Refer back to [the section above](##the-benefits-of-sentinel-registry-and-workspaces)
- Cost estimation
  - Estimate cost of resources being provisioned by the configuration
- API
  - A subset of TFC features can be accessed via API
- ServiceNow
  - Integration possible / available!

----

## End Of Objective 9
