####################################################################################################
#   data.tf                                                                                        #
####################################################################################################

data "unifi_network" "network" {
    name  = var.client.network == null ? "Default" : var.client.network
    site  = var.client.site == null ? "default" : var.client.site
}

data "unifi_user_group" "user_group" {
    name  = var.client.user.user_group == null ? "Default" : var.client.user.user_group
    site  = var.client.site == null ? "default" : var.client.site
}
