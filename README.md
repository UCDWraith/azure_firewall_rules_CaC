# Introduction

This project will create Azure firewall rule sets using a Configuration-as-Code (CaC) approach. The firewall rule sets will be specified as input variables:

```terraform
firewall_policies = [
  {
    id       = "/subscriptions/<MY_SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>/providers/Microsoft.Network/firewallPolicies/<FIREWALL_POLICY_NAME>",
    name     = "Base_FW_Rule_AustraliaEast",
    priority = "500"
  },
  {
    id       = "/subscriptions/<MY_SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>/providers/Microsoft.Network/firewallPolicies/<FIREWALL_POLICY_NAME2>",
    name     = "Base_FW_Rule_AustraliaSoutheast",
    priority = "500"
  },
]
```

The **name** parameter will be parsed against the firewall rule templates and a rule created in the firewall policy when matched. Common rule's like allowing outbound HTTPS access may be added across multiple firewall rule sets where more specific NAT configuration rules may only make sense against their local firewall.

This methodology allows rule sets to be created per project or service and additional tracking information - RFC's, Descriptions etc. stored with the relevant rule. In this way a rule base can clearly be tied to a relevant landing zone facilitating greater lifecycle management on your overall firewall rule base.

# Getting Started

1. Update the **providers.tf** file with an appropriate subscription ID and backend configuration (Comment out if using a local state file)
2. Update the appropriate **./environments/${ENVIRONMENT}/${ENVIRONMENT}-ado-variables.tfvars** file as per the included sample files
3. Review the sample firewall rules and add/update a template as required under the relevant folder **./modules/create_few_policy/lib/firewall_rule_collections/<RULE_TYPE>**. The folders align with the Azure firewall defaults:
   - Application rules
   - NAT rules
   - Network rules
4. Use either a DevOps pipeline (sample is included) to plan the build and create an artifact for use in a release pipeline [Tutorial TBA](https://ucdwraith.github.io/categories/) or extend the pipeline to include a `terraform apply` stage.
5. Alternatively from a command line:

   ```terraform
   terraform init -upgrade
   terraform fmt -recursive
   terraform validate
   terraform plan -out main.tfplan -var-file ./environments/${ENVIRONMENT}/${ENVIRONMENT}-ado-variables.tfvars
   terraform apply main.tfplan
   ```

# Microsoft Cloud Adoption Framework
I wrote this code to dovetail with my implementation of [Microsofts Cloud Adoption Framework in Terraform](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest). As such this code would target your **Platform/Connectivity** management group using that subscription or an appropriate one within which your Azure Firewalls are situated.

Specifically this rule set enables the required HTTPS outbound access for the Linux Virtual Machine Scale Set (VMSS) agents to access a public Blob storage endpoint and Azure DevOps to operate in a named 'Agent pool'. Please refer to my project to automate the VMSS agent build [here](https://github.com/UCDWraith/azure-devops-vmss-agents)

## Additional considerations
This format also lends itself towards an opportunity to create Azure firewall rules with an expiry date. By extending the relevant *.json* file to include an *expiry_date* field a conditional expression can be built which would remove the validity of a rule subsequent to that date and a `terraform apply` of the resulting plan would remove that rule or **disable** it. A secondary conditional evaluation might delete the **disabled** rules after a period.

Regular re-application of your rule base assists continual alignment towards agreed and documented change and standards, reduces organisational drift and increases Compliance.

By default the [caf-enterprise-scale](https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest) creates an empty firewall policy with a default deny rule configured. Adding the functionality from this project to an additional CI/CD pipeline sequesters the functionality and back end tfstate configurations from the primary deployment and allows independent application of both projects through correspondingly restricted **service connections** within Azure DevOps.

# Contribute

It would be great to hear your thoughts/feedback on whether this has helped. If you think I can help your organisation please reach out.
