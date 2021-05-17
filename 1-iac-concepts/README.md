# Objective 1: Understand Infrastructure-as-Code (IaC) Concepts

## 1A: Explain What IaC Is

### A Definition of "IaC"

IaC describes infrastructure using a high-level configuration syntax.  

This provides a blueprint of the data centre which can be versioned and managed as per any other code, plus it can also be shared and reused as required.

----

_Why Did IaC Become "A Thing"?_

The adoption of **cloud** is the big driver for IaC.

- Everything is API-driven
- Infrastructure lifespan is (much) shorter
- The scale of infrastructure is much greater
- There's a requirement for elasticity
  - To scale up
    - Meet demand / performance needs
  - To scale down
    - Reduce charges (in the cloud, you generally pay for what you consume)

As opposed to "point and click" operations in the traditional data centre.

----

_What Else Does It Offer?_

IaC is an enabler of **automation** and **versioning**.

It's machine-readable **and** human-readable (versus the scripts of yesteryear that only machines could read)

It promotes **reusability** e.g. modules.

It also provides **documentation** in and of itself, as the code describes the infrastructure.
  
----

## 1B: Describe the Advantages of IaC Patterns

### IaC Makes Infrastructure More Reliable

IaC has the following qualities / benefits.

- Idempotent
  - Code can be (re)applied multiple times and it will always give the **same outcome**
- Consistent
  - Versus human agent creating variations / omissions in workflow steps
  - Infrastructure can be mirrored across environments and cloud regions
- Repeatable
  - Versus human agent (see above)
- Predictable
  - Versus human agent (see above)
  - Test and review code before deployment
- Automation-friendly
  - Supports deployment at scale

### IaC Makes Infrastructure More Manageable

You can revise the existing IaC to be able to scale out and / or make other changes as required.

It improves efficiency, and lowers risk and costs.

----

## End of Objective One
