###################################################################################################
#   variable.tf                                                                                   #
###################################################################################################

variable "client" {
  description   = "Common variable for ressources managed by the unifi_client module"
  type          = object({
    mac                     = string
    name                    = string
    network                 = optional(string, null)
    site                    = optional(string, null)
    user                    = optional(object({
      allow_existing          = optional(bool, null)
      blocked                 = optional(bool, null)
      dev_id_override         = optional(number, null)
      fixed_ip                = optional(string, null)
      local_dns_record        = optional(string, null)
      note                    = optional(string, null)
      skip_forget_on_destroy  = optional(bool, null)
      user_group              = optional(string, null)
    }), {})
    account                 = optional(object({
      enabled                 = optional(bool, true)
      tunnel_medium_type      = optional(number, null)
      tunnel_type             = optional(number, null)
    }), { enabled = false })
  })
  validation {
    # check if var.client.mac contains a valid MAC address
    condition     = can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", var.client.mac))
    error_message = <<-EOF
      Value for 'var.client.mac' is invalid: ${var.client.mac}.
      Must be a valid MAC address in the format 00:1A:2B:3C:4D:5E" or "00:1a:2b:3c:4d:5e" only.
    EOF
  }
  validation {
    # check if var.client.user.fixed_ip is null or contains a valid IPv4 value
    condition     = var.client.user.fixed_ip == null ? true : can(cidrnetmask(join("/", [var.client.user.fixed_ip, "32"])))
    error_message = <<-EOF
      Value for 'var.client.user.fixed_ip' is invalid: ${var.client.user.fixed_ip == null ? 0 : var.client.user.fixed_ip}
      Must be a valid address in IPv4 format or null only.
    EOF
  }
}
