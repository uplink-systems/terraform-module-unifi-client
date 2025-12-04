###################################################################################################
#   main.tf                                                                                       #
###################################################################################################

resource "unifi_user" "user" {
    mac                     = var.client.mac
    name                    = var.client.name
    network_id              = data.unifi_network.network.id
    site                    = var.client.site == null ? "default" : var.client.site
    allow_existing          = var.client.user.allow_existing == null ? true : var.client.user.allow_existing
    blocked                 = var.client.user.blocked == null ? false : var.client.user.blocked
    dev_id_override         = var.client.user.dev_id_override
    fixed_ip                = var.client.user.fixed_ip
    local_dns_record        = var.client.user.fixed_ip == null ? null : var.client.user.local_dns_record
    note                    = var.client.user.note
    skip_forget_on_destroy  = var.client.user.skip_forget_on_destroy == null ? false : var.client.user.skip_forget_on_destroy
    user_group_id           = data.unifi_user_group.user_group.id
}

resource "unifi_account" "account" {
    for_each                = var.client.account.enabled ? [1] : []
    name                    = upper(trim(var.client.mac, ":"))
    password                = upper(trim(var.client.mac, ":"))
    network_id              = data.unifi_network.network.id
    site                    = var.client.site == null ? "default" : var.client.site
    tunnel_medium_type      = var.client.account.tunnel_medium_type
    tunnel_type             = var.client.account.tunnel_type
    depends_on              = [ unifi_user.user ]
}
