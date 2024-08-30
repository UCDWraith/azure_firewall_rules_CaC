variable "firewall_policies" {
  type = list(object({
    id       = string
    name     = string
    priority = string
  }))
  description = "List of firewall policies with IDs and names"
  default     = []
}