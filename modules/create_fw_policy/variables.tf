variable "firewall_policy_id" {
  type        = string
  description = "The ID of the firewall policy to which the rules will be assigned."
}

variable "firewall_rule_collection_group" {
  type        = string
  description = "The name of the firewall rule collection group"
}

variable "firewall_rule_collection_priority" {
  type        = string
  description = "The priority to be assigned to the rule collection group"
}