locals {
  firewall_network_rule_files     = fileset("${path.module}/lib/firewall_rule_collections/network_rules", "network_rule_collection*.json")
  firewall_application_rule_files = fileset("${path.module}/lib/firewall_rule_collections/application_rules", "application_rule_collection*.json")
  firewall_nat_rule_files         = fileset("${path.module}/lib/firewall_rule_collections/nat_rules", "nat_rule_collection*.json")

  # Load and filter application rule files based on the target_rule_collection_group
  filtered_firewall_application_rule_files = [
    for file in fileset("${path.module}/lib/firewall_rule_collections/application_rules", "*.json") :
    file if contains(jsondecode(file("${path.module}/lib/firewall_rule_collections/application_rules/${file}")).target_rule_collection_group, var.firewall_rule_collection_group)
  ]

  # Load and filter network rule files based on the target_rule_collection_group
  filtered_firewall_network_rule_files = [
    for file in fileset("${path.module}/lib/firewall_rule_collections/network_rules", "*.json") :
    file if contains(jsondecode(file("${path.module}/lib/firewall_rule_collections/network_rules/${file}")).target_rule_collection_group, var.firewall_rule_collection_group)
  ]

  # Load and filter nat rule files based on the target_rule_collection_group
  filtered_firewall_nat_rule_files = [
    for file in fileset("${path.module}/lib/firewall_rule_collections/nat_rules", "*.json") :
    file if contains(jsondecode(file("${path.module}/lib/firewall_rule_collections/nat_rules/${file}")).target_rule_collection_group, var.firewall_rule_collection_group)
  ]
}
