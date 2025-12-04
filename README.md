## Module 'terraform-module-unifi-client'

> [!NOTE]  
> This module is currently still in alpha state and not finally released.  
> Therefore, please use carefully!  

### Description

This module is intended to create and manage client devices (unifi_user) on a Unifi Network Controller. Optionally the module can create an associated account (unifi_account) for authentication/authentication/accounting (AAA) for wired or wireless networks using UniFi gateway's built-in RADIUS server.  

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_unifi"></a> [ubiquiti-community\/unifi](#requirement\_ubiquiti-commpunity\_unifi) | >= 0.41.3 |

### Resources

| Name | Type |
|------|------|
| [unifi_user.user](https://registry.terraform.io/providers/ubiquiti-community/unifi/latest/docs/resources/user) | resource |
| [unifi_account.account](https://registry.terraform.io/providers/ubiquiti-community/unifi/latest/docs/resources/account) | resource |

### Inputs
  
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client"></a> [client](#input\_client) | 'var.client' is the main variable for unifi_user and unifi_account resources' attributes | <pre>type        = object({<br>  mac                     = string<br>  name                    = string<br>  allow_existing          = optional(bool, true)<br>  blocked                 = optional(bool, false)<br>  dev_id_override         = optional(number,null)<br>  fixed_ip                = optional(string, null)<br>  local_dns_record        = optional(string, null)<br>  network_id              = optional(string, null)<br>  note                    = optional(string, null)<br>  site                    = optional(string, null)<br>  skip_forget_on_destroy  = optional(bool, false)<br>  user_group_id           = optional(string, null)<br>})</pre> | none | yes |

#### Notes
  
There are several Terraform provider available for UniFi under active development to select from. This module is based on the provider *ubiquiti-community/unifi*. If your code is based on another UniFi provider (e.g. *filipowm/unifi*, which currently provides more available resources to manage) you need to configure and add the *ubiquiti-community/unifi* provider as an additional (non-default) provider config with a custom local name when using the module:  

```
terraform {
  required_providers {
    unifi           = {
      <your default provider for UniFi resources>
    }
    unifi-ubiquiti  = {
      source  = "ubiquiti-community/unifi"
      version = ">= 0.41.3"
    }
  }
}
  
provider "unifi" = {
  <your default provider's settings>
}
provider "unifi-ubiquiti" = {
  api_key         = ...
  api_url         = ...
  ...
}
  
module "unifi-client"
  for_each  = ...
  source    = ...
  <Module-specific inputs>
  providers = {
    unifi     = unifi-ubiquiti
  }
```
  
The module can create/manage both, a client device and an associated account for AAA. A UniFi gateway with an enabled built-in RADIUS server must be setup to create associated accounts. Leave the account attributes unconfigured to skip account creation or if a 3rd party gateway is used.  
  
The provider requires that the attributes <code>network_id</code> and <code>user_group_id</code> contain the Unifi-internal ID of the network / user group. However, the name of the objects must be specified in the module variable instead, because it has a built-in feature to "translate" these names to their corresponding IDs using data sources. That's why the variable's attributes in the module are labeled as <code>network</code> and <code>user_group</code> for better understanding.  
  
The provided mac address is used for both resources, <code>unifi_user</code> and <code>unifi_account</code>. The module converts the mac address to Unifi's built-in RADIUS server's default format for username/password ("*AABBCCDDEEFF*") for the <code>unifi_account</code> resources.  
  
The attribute <code>fixed_ip</code> can only be used in environments with a UniFi Gateway or a UniFi layer-3 switch. Otherwise the resource will fail to create if not null.  
  
The attribute <code>local_dns_record</code> can only be used in combination with the <code>fixed_ip</code> attribute. The module validates the dependency and sets the value to <code>null</code>, too, if <code>fixed_ip</code> is null.  
  
<details>
<summary><b>Using the variables in the root module</b></summary>

######
The following lines explain how the main variable in the root module has to be defined with minimum required settings if the module is used with a for_each loop and shall create multiple resources:  

```
variable "client" {
  description = ""
  type        = object({
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
      tunnel_medium_type      = optional(number, null)
      tunnel_type             = optional(number, null)
    }))
  })
}
  
module "client" {
  source                  = "github.com/uplink-systems/terraform-module-unifi-client"
  for_each                = var.client
  mac                     = each.value.mac
  name                    = each.value.name
  site                    = each.value.site
  network                 = each.value.network
  user                    = {
    allow_existing          = each.value.allow_existing
    blocked                 = each.value.blocked
    dev_id_override         = each.value.dev_id_override
    fixed_ip                = each.value.fixe_ip
    local_dns_record        = each.value.local_dns_record
    note                    = each.value.note
    skip_forget_on_destroy  = each.value.skip_forget_on_destroy
    user_group              = each.value.user_group
  }
  account                 = {
    tunnel_medium_type      = each.value.account.tunnel_medium_type
    tunnel_type             = each.value.account.tunnel_type
  }
}
```
</details>
  
### Outputs

| Name | Description |
|------|-------------|
| <a name="output_unif_user"></a> [unifi\_user](#output\_unifi\_user) | list of all exported attributes values from the <code>unifi_user</code> resources (Client device)  |
| <a name="output_unif_account"></a> [unifi\_account](#output\_unifi\_account) | list of all exported attributes values from the <code>unifi_account</code> resources (RADIUS acocunt)  |

  
### Known Issues
  
Known issues are documented with the GitHub repo's issues functionality. Please filter the issues by **Types** and select **Known Issue** to get the appropriate issues and read the results carefully before using the module to avoid negative impacts on your infrastructure.  
  
<a name="known_issues"></a> [list of Known Issues](https://github.com/uplink-systems/terraform-module-unifi-client/issues?q=type%3A%22known%20issue%22)  