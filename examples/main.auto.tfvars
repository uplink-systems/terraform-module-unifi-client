###################################################################################################
#   main.auto.tfvars                                                                              #
###################################################################################################

client = {
  "001A2B3C4D5E" = {
    mac               = "00:1A:2B:3C:4D:5E"
    name              = "desktop_001"
    site              = "UiSite2"
    user              = {
      blocked           = true
      note              = "Blocked desktop PC of employee XYZ"
      user_group        = "desktops"
    }
  }
  "00A1B2C3D4E5" = {
    mac               = "00:a1:b2:c3:d4:e5"
    name              = "laptop_002"
    network           = "vlan_0011"
    site              = "UiSite1"
    user              = {
      fixed_ip          = "192.168.1.101"
      local_dns_record  = "laptop_002.domain.internal"
      note              = "Laptop of the Big Boss"
      user_group        = "laptops"
    }
    account           = {
      enabled           = true
    }
  }
}
