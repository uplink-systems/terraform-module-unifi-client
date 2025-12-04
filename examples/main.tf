###################################################################################################
#   main.tf                                                                                       #
###################################################################################################


# example 1: set clients variables' values via declared variable

variable "clients" {
  type        = list(object({
    mac                     = string
    name                    = string
    network                 = optional(string, null)
    site                    = optional(string, null)
    user                    = {
      allow_existing          = optional(bool, true)
      blocked                 = optional(bool, false)
      dev_id_override         = optional(number, null)
      fixed_ip                = optional(string, null)
      local_dns_record        = optional(string, null)
      note                    = optional(string, null)
      skip_forget_on_destroy  = optional(bool, false)
      user_group              = optional(string, null)
    }
    account                 = optional(object({
      enabled                 = optional(bool, true)
      tunnel_medium_type      = optional(number, null)
      tunnel_type             = optional(number, null)
    }), { enabled = false })
  }))
}

module "clients" {
  for_each                  = { for client in var.clients : client.mac => client }
  source                    = "github.com/uplink-systems/terraform-module-unifi-client"
  mac                       = each.key
  name                      = each.value.name
  network                   = each.value.network
  site                      = each.value.site
  user                      = {
    allow_existing            = each.value.user.allow_existing
    blocked                   = each.value.user.blocked
    dev_id_override           = each.value.user.dev_id_override
    fixed_ip                  = each.value.user.fixed_ip
    local_dns_record          = each.value.user.local_dns_record
    note                      = each.value.user.note
    skip_forget_on_destroy    = each.value.user.skip_forget_on_destroy
    user_group                = each.value.user.user_group
  }
  account                   = {
    tunnel_medium_type        = each.value.account.tunnel_medium_type
    tunnel_type               = each.value.account.tunnel_type
  }
}


# example 2: set clients variables' values via CSV input file

locals {
  inputfile   = csvdecode(file("${path.module}/main.auto.csv"))
  clients     = { for client in local.inputfile : client.mac => client }
}

module "clients_csv" {
  for_each                  = local.clients
  source                    = "github.com/uplink-systems/terraform-module-unifi-client"
  mac                       = each.key
  name                      = each.value.name
  network                   = each.value.network
  site                      = each.value.site
  user                      = {
    allow_existing            = each.value.allow_existing
    blocked                   = each.value.blocked
    dev_id_override           = each.value.dev_id_override
    fixed_ip                  = each.value.fixed_ip
    local_dns_record          = each.value.local_dns_record
    note                      = each.value.note
    skip_forget_on_destroy    = each.value.skip_forget_on_destroy
    user_group                = each.value.user_group
  }
  account                   = {
    tunnel_medium_type        = each.value.tunnel_medium_type
    tunnel_type               = each.value.tunnel_type
  }
}
