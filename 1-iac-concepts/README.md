# Objective 1: Understand Infrastructure-as-Code (IaC) Concepts

## 1A: Explain What IaC Is

### In Search of a Definition of "IaC"

```plaintext
The HashiCorp definition:

[IaC] is the process of managing infrastructure in a file or files rather than manually configuring resources in a user interface. A resource in this instance is any piece of infrastructure in a given environment, such as a virtual machine, security group, network interface, etc.

Source: https://learn.hashicorp.com/tutorials/terraform/infrastructure-as-code

----

[IaC] is a practice in which infrastructure is provisioned and managed using code and software development techniques, such as version control and continuous integration. The cloud’s API-driven model enables developers and system administrators to interact with infrastructure programmatically, and at scale, instead of needing to manually set up and configure resources. Thus, engineers can interface with infrastructure using code-based tools and treat infrastructure in a manner similar to how they treat application code. Because they are defined by code, infrastructure and servers can quickly be deployed using standardized patterns, updated with the latest patches and versions, or duplicated in repeatable ways.

Source: https://aws.amazon.com/devops/what-is-devops/

----

[IaC] is the management of infrastructure (networks, virtual machines, load balancers, and connection topology) in a descriptive model, using the same versioning as DevOps team uses for source code. Like the principle that the same source code generates the same binary, an IaC model generates the same environment every time it is applied. IaC is a key DevOps practice and is used in conjunction with continuous delivery.

Source: https://docs.microsoft.com/en-us/devops/deliver/what-is-infrastructure-as-code
```

----

_Why Did IaC Become "A Thing"?_

The adoption of **cloud** is the big driver for IaC.

- Everything is **API-driven**
- Infrastructure **lifespan** is shorter
- The **scale** of infrastructure is greater
- There's a requirement for **elasticity**
  - To scale up
    - Meet demand / performance needs
  - To scale down
    - Reduce charges (in the cloud, you generally pay for what you consume)

As opposed to "point and click" operations in the traditional data centre.

----

_What Else Does It Offer?_

- IaC is an enabler of **automation** and **versioning**
- It's **machine-readable** and **human-readable**
  - Versus the scripts of yesteryear that only machines could read
- It promotes **reusability**
  - E.g. modules
- It provides **documentation** (in and of itself)
  - The code describes the infrastructure
  
----

## 1B: Describe the Advantages of IaC Patterns

### IaC Makes Infrastructure More Reliable

IaC provides the following benefits.

- **Idempotent**
  - Code can be (re)applied multiple times and it will always give the **same outcome**
- **Consistent**
  - Versus a human agent (inadvertently) generating variations / omissions in workflow steps
  - Infrastructure can be mirrored across environments and cloud regions
- **Repeatable**
  - Versus human agent workflow (see above)
- **Predictable**
  - Versus human agent workflow (see above)
  - Test and review code before deployment
- **Automation-friendly**
  - Supports deployment at scale

### IaC Makes Infrastructure More Manageable

You can **revise** the existing IaC to be able to scale out and / or make other changes as required.

It improves **efficiency** and **lowers risk and costs**.

----

## End of Objective 1
