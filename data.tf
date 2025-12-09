####################################################################################################
#   data.tf                                                                                        #
####################################################################################################

data "unifi_network" "network" {
    count = var.client.network == null ? 0 : 1
    name  = var.client.network
    site  = var.client.site
}

data "unifi_user_group" "user_group" {
    name  = var.client.user.user_group == null ? "Default" : var.client.user.user_group
    site  = var.client.site
}
