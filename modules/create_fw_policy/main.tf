resource "azurerm_firewall_policy_rule_collection_group" "fw_policy_rules" {
  firewall_policy_id = var.firewall_policy_id
  name               = var.firewall_rule_collection_group
  priority           = var.firewall_rule_collection_priority

  dynamic "network_rule_collection" {
    for_each = {
      for idx, file in local.filtered_firewall_network_rule_files :
      idx => jsondecode(file("${path.module}/lib/firewall_rule_collections/network_rules/${file}"))
    }

    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.value.name
          description           = rule.value.description
          destination_addresses = rule.value.destination_addresses
          destination_fqdns     = rule.value.destination_fqdns
          destination_ip_groups = rule.value.destination_ip_groups
          destination_ports     = rule.value.destination_ports
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = rule.value.source_ip_groups
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = {
      for idx, file in local.filtered_firewall_application_rule_files :
      idx => jsondecode(file("${path.module}/lib/firewall_rule_collections/application_rules/${file}"))
    }

    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules

        content {
          name              = rule.value.name
          description       = rule.value.description
          source_addresses  = rule.value.source_addresses
          destination_fqdns = rule.value.destination_fqdns
          protocols {
            type = rule.value.protocol_type
            port = rule.value.protocol_port
          }
        }
      }
    }
  }

  # DNAT rule cannot be associated to more than 1 firewall
  dynamic "nat_rule_collection" {
    for_each = {
      for idx, file in local.filtered_firewall_nat_rule_files :
      idx => jsondecode(file("${path.module}/lib/firewall_rule_collections/nat_rules/${file}"))
    }

    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules

        content {
          name             = rule.value.name
          description      = rule.value.description
          protocols        = rule.value.protocols
          source_addresses = rule.value.source_addresses
          # source_ip_groups = rule.value.source_ip_groups
          destination_address = rule.value.destination_address
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
}