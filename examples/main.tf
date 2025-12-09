###################################################################################################
#   main.tf                                                                                       #
###################################################################################################

variable "client" {
  type = map(object({
    mac     = string
    name    = string
    network = optional(string, null)
    site    = optional(string, null)
    user = {
      allow_existing         = optional(bool, true)
      blocked                = optional(bool, false)
      dev_id_override        = optional(number, null)
      fixed_ip               = optional(string, null)
      local_dns_record       = optional(string, null)
      note                   = optional(string, null)
      skip_forget_on_destroy = optional(bool, false)
      user_group             = optional(string, null)
    }
    account = optional(object({
      enabled            = optional(bool, true)
      tunnel_medium_type = optional(number, null)
      tunnel_type        = optional(number, null)
    }), { enabled = false })
  }))
}

module "unifi_client" {
  for_each  = var.client
  source    = "github.com/uplink-systems/terraform-module-unifi-client"
  client    = each.value
}
