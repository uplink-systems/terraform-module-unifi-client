####################################################################################################
#   terraform.tf                                                                                   # 
####################################################################################################

terraform {
  required_providers {
    unifi = {
      source  = "registry.terraform.io/ubiquiti-community/unifi"
      version = ">= 0.41.3"
    }
  }
  required_version = ">= 0.12.0"
}
