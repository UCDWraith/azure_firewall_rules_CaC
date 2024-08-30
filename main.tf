module "firewall_rules" {
  source = "./modules/create_fw_policy"

  for_each = { for policy in var.firewall_policies : policy.id => policy }

  firewall_policy_id                = each.value.id
  firewall_rule_collection_group    = each.value.name
  firewall_rule_collection_priority = each.value.priority
}