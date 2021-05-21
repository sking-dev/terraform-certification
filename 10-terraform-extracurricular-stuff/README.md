# Objective 10: Terraform Extracurricular Stuff

NOTE: This is not an official exam objective (phew!)

----

## Terraform - Things to Understand

_Things that currently puzzle me about Terraform._

The plan is, gather the answers to these questions on the journey to certification!

- How to set up Terraform from scratch in the cloud?
  - In Azure?
  - In AWS?
    - Can I dredge this up from my memory?
- How to manage multiple versions of Terraform?
  - On Linux?
  - On Windows?
- When and how to upgrade Terraform?
  - Minor versions?
  - Major versions?
- When and how to upgrade providers?
  - E.g. `azurerm`
- How to import brownfield resources into Terraform configurations?
- How to write a module?
- Terraform Cloud - are free accounts / trials available, to have a play around?

----

## Terraform - How to Do Things

These are (very) rough notes on best practice / good practice concepts to investigate further.

### Modules

Look at - and learn from - how other people write them.

The following reference sites were suggested in a CloudSkills training course.

- [gruntwork.io](https://gruntwork.io/)
  - Note use of "test" directory
    - If you change the module, you'll need to test it!  
  - Also check out the "examples" directory
- Cloud Posse
- Terraform Registry

### Remote State

Version tracking (blob versioning)

### Variables

Always include a good description!

----

## End of Objective 10
