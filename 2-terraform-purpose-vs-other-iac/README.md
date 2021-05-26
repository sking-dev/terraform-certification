# Objective 2: Understand Terraform’s Purpose (Versus Other IaC)

## Overview

_Other IaC Tools Are Available!_

Several public cloud providers offer their own proprietary IaC solutions.

```plaintext
AliCloud = Alibaba Cloud Resource Orchestration Service
AWS      = CloudFormation
Azure    = ARM Templates
GCP      = Cloud Deployment Manager

Although this one probably doesn't count:

OPC      = Resource Manager *but* this uses Terraform (hurrah!)
```

There are also other third party IaC solutions that offer different features and approaches to achieve the goal of automated infrastructure deployment.

_So Why Should I Choose Terraform?_

Good question!  

It's important to know **what makes Terraform different** from other IaC solutions.

So here we go..!

----

## Terraform Is Multi-cloud / Provider-agnostic

Terraform is **agnostic** when it comes to the public cloud.

Using a cloud provider's proprietary IaC tooling can effectively tie you in to that particular cloud.

Terraform leverages **providers** for each different
cloud.

It also supports other solutions including VMware, Kubernetes, and MySQL.

It provides a common tool, process, and language
(HCL) that can be used across **multiple clouds and services** (versus focusing on a specific cloud or service)

NOTE: "HCL" stands for, "HashiCorp Configuration Language".

----

## Terraform Uses State

_What Is "State" In Terraform Speak?_

State is the way that Terraform keeps track of what's been deployed to the live environment in relation to what's been defined in the configuration (code)

When you create a resource - e.g. a Resource Group in Azure Resource Manager - Terraform creates an entry in state that maps the metadata about the resource to key/value pairs in the entry.

### Here's What an Azure Resource Group Entry Looks Like in a State File

```json
  "resources": [
    {
      "mode": "managed",
      "type": "azurerm_resource_group",
      "name": "rg_cert_objective_two",
      "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "/subscriptions/subscription_id/resourceGroups/rg-sking-dev-apples",
            "location": "northeurope",
            "name": "rg-sking-dev-apples",
            "tags": null,
            "timeouts": null
          },
```

_What Are the Benefits / Functions of State?_

- **Idempotence**
  - Terraform uses state to check if the live environment matches the desired configuration
  - This means that **only resources that need to change will be changed** (it will leave all other resources alone)
- **Dependencies**
  - Terraform maintains a list of dependencies in the state file so it can properly deal with dependencies that no longer exist in the current configuration
    - If a naughty team member should happen to delete a resource without using Terraform (e.g. via the Azure Resource Manager portal) Terraform will detect that the resource no longer exists and will reinstate (redeploy) it as per the configuration (code)
      - See <https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform> for more information about this type of scenario
- **Performance**
  - When generating an **execution plan**, Terraform can check resources and their attributes more efficiently via the state file (versus querying each object directly via the cloud provider's API)
    - The benefit / value of this increases as your infrastructure deployment grows
- **Collaboration**
  - State tracks the **version** of an applied configuration
  - It can be stored remotely in a **shared location** to enable team collaboration on deployments
  - State supports **locking** during updates e.g. to avoid conflicts from multiple simultaneous updates

----

## End of Objective Two
