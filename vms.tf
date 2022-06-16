# resource "azurerm_virtual_machine_scale_set" "scaleSet" {
#   name                = "vmscaleset"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   upgrade_policy_mode = "Manual"

#   sku {
#     name     = "Standard_DS1_v2"
#     tier     = "Standard"
#     capacity = 1
#   }

#   storage_profile_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   storage_profile_os_disk {
#     name              = ""
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   storage_profile_data_disk {
#     lun           = 0
#     caching       = "ReadWrite"
#     create_option = "Empty"
#     disk_size_gb  = 10
#   }

#   os_profile {
#     computer_name_prefix = "vmlab"
#     admin_username       = "app"
#     admin_password       = var.secret
#     # custom_data          = file("web.conf")
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   network_profile {
#     name    = "terraformnetworkprofile"
#     primary = true

#     ip_configuration {
#       name                                   = "IPConfiguration"
#       subnet_id                              = azurerm_subnet.public.id
#       load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backendPool.id]
#       primary                                = true
#     }
#   }

#   #  tags = var.tags
# }
# # Create virtual machine terminal
# resource "azurerm_linux_virtual_machine" "appserver" {
#   name                  = "terminal"
#   location              = var.location
#   resource_group_name   = var.resource_group_name
#   network_interface_ids = [azurerm_network_interface.appNic.id]
#   size                  = "Standard_F2"
#   os_disk {
#     name                 = "myOsDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }


#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   computer_name                   = "terminal"
#   admin_username                  = "app"
#   admin_password                  = var.secret
#   disable_password_authentication = false

# }
# # Create virtual machine dbServer
# resource "azurerm_linux_virtual_machine" "dbserver" {
#   name                  = "DbServer"
#   location              = var.location
#   resource_group_name   = var.resource_group_name
#   network_interface_ids = [azurerm_network_interface.appNic.id]
#   size                  = "Standard_D2_v2"
#   os_disk {
#     name                 = "myOsDbDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }


#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }



#   computer_name                   = "appserver"
#   admin_username                  = "db"
#   admin_password                  = var.secret
#   disable_password_authentication = false

# }


# resource "azurerm_postgresql_flexible_server" "psql" {
#   name                   = "psql"
#   resource_group_name    = var.resource_group_name
#   location               = var.location
#   version                = "13" # "12"
#   delegated_subnet_id    = azurerm_subnet.privete.id
#   private_dns_zone_id    = azurerm_private_dns_zone.dns.id
#   administrator_login    = "alex"
#   administrator_password = var.secret
#   zone                   = "1"
#   create_mode            = "Default"
#   storage_mb             = 32768

#   #  virtual_network_id    = azurerm_virtual_network.vnet.id #my edit


#   # sku_name = "GP_Standard_D4s_v3"
#   sku_name = "B_Standard_B1ms"


#   #   tags = {
#   #   name = var.tags
#   # }
#   depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_link] #my edit



# }
# resource "azurerm_postgresql_flexible_server_database" "db" {
#   name      = "postgres"
#   server_id = azurerm_postgresql_flexible_server.psql.id
#   collation = "en_US.utf8"
#   charset   = "utf8"

# }

# resource "azurerm_postgresql_flexible_server_firewall_rule" "fwconfig" {
#   name      = "example-fw"
#   server_id = azurerm_postgresql_flexible_server.psql.id

#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "255.255.255.255"

# }
# resource "azurerm_postgresql_flexible_server_configuration" "flexible_server_configuration" {
#   name      = "require_secure_transport"
#   server_id = azurerm_postgresql_flexible_server.psql.id
#   value     = "off"


# }



# resource "azurerm_postgresql_flexible_server" "SQL" {
#   name                   = "psqlflexibleserver"
#   resource_group_name    = var.resource_group_name
#   location               = var.location
#   version                = "12"
#   delegated_subnet_id    = azurerm_subnet.privete.id
#   private_dns_zone_id    = azurerm_private_dns_zone.rioqsiaustraliaeastcloudappazurecom
#   administrator_login    = "DB"
#   administrator_password = var.secret
#   zone                   = "1"

#   storage_mb = 32768

#   sku_name   = "GP_Standard_D4s_v3"
#   depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_link]


# }
# resource "azurerm_linux_virtual_machine" "appserver4" {
#   name                  = "AppServer4n"
#   location              = var.location
#   resource_group_name   = var.resource_group_name
#   network_interface_ids = [azurerm_network_interface.appNic2.id]
#   size                  = "Standard_F2"
#   os_disk {
#     name                 = "myOsDisk2"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   computer_name                   = "appserver2"
#   admin_username                  = "app"
#   admin_password                  = "Alex310224993"
#   disable_password_authentication = false
# }

# }
# resource "azurerm_linux_virtual_machine" "appserver3" {
#   name                  = "AppServer3"
#   location              = var.location
#   resource_group_name   = var.resource_group_name
#   network_interface_ids = [azurerm_network_interface.appNic3.id]
#   size                  = "Standard_F2"
#   os_disk {
#     name                 = "myOsDisk3"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   computer_name                   = "appserver3"
#   admin_username                  = "app"
#   admin_password                  = "Alex310224993"
#   disable_password_authentication = false

# }

# # Create virtual machine DBServer
# # resource "azurerm_linux_virtual_machine" "dbserver" {
# #   name                  = "db"
# #   location              = var.location
# #   resource_group_name   = var.resource_group_name
# #   network_interface_ids = [azurerm_network_interface.dbNic.id]
# #   size                  = "Standard_DS1_v2"
# #   os_disk {
# #     name                 = "myOs_DbDisk"
# #     caching              = "ReadWrite"
# #     storage_account_type = "StandardSSD_LRS"
# #   }

# #   source_image_reference {
# #     publisher = "Canonical"
# #     offer     = "UbuntuServer"
# #     sku       = "18.04-LTS"
# #     version   = "latest"
# #   }

# #   computer_name                   = "dbserver"
# #   admin_username                  = "db"
# #   admin_password                  = "Alex310224993"
# #   disable_password_authentication = false

# # }

# # scale_set

# resource "azurerm_virtual_machine_scale_set" "scaleSet" {
#   name                = "scaleSet"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   upgrade_policy_mode = "Manual"

#   sku {
#     name     = "Standard_DS1_v2"
#     tier     = "Standard"
#     capacity = 1
#   }

#   storage_profile_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   storage_profile_os_disk {
#     name              = ""
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   #   storage_profile_data_disk {
#   #     lun           = 0
#   #     caching       = "ReadWrite"
#   #     create_option = "Empty"
#   #     disk_size_gb  = 10
#   #   }

#   os_profile {
#     computer_name_prefix = "scaleSetVm"
#     admin_username       = "app"
#     admin_password       = "Alex310224993"
#     # custom_data          = file("web.conf")
#   }



#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   network_profile {
#     name    = "terraformnetworkprofile"
#     primary = true

#     ip_configuration {
#       name                                   = "IPConfiguration"
#       subnet_id                              = azurerm_subnet.public.id
#       load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backendPool.id]
#       primary                                = true
#     }
#   }
# }


#   boot_diagnostics {
#     storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
#   }

# resource "azurerm_lb" "vmss" {
#   name                = "vmss-lb"
#   location            = var.location
#   resource_group_name = var.resource_group_name


#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.publicIpLB.id
#   }


# }

# resource "azurerm_lb_backend_address_pool" "bpepool" {
#   loadbalancer_id = azurerm_lb.vmss.id
#   name            = "BackEndAddressPool"

# }

# resource "azurerm_lb_probe" "vmss" {
#   #   resource_group_name = "week5"
#   loadbalancer_id = azurerm_lb.vmss.id
#   name            = "ssh-running-probe"
#   port            = var.application_port
# }

# resource "azurerm_lb_rule" "lbnatrule" {
#   #   resource_group_name = var.resource_group_name
#   loadbalancer_id = azurerm_lb.vmss.id
#   name            = "http"
#   protocol        = "Tcp"
#   frontend_port   = var.application_port
#   backend_port    = var.application_port
#   #   backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
#   frontend_ip_configuration_name = "PublicIPAddress"
#   probe_id                       = azurerm_lb_probe.vmss.id
# }


#  tags = var.tags
# }

# resource "azurerm_public_ip" "jumpbox" {
#  name                         = "jumpbox-public-ip"
#  location                     = var.location
#  resource_group_name          = azurerm_resource_group.vmss.name
#  allocation_method            = "Static"
#  domain_name_label            = "${random_string.fqdn.result}-ssh"
#  tags                         = var.tags
# }

# resource "azurerm_network_interface" "jumpbox" {
#  name                = "jumpbox-nic"
#  location            = var.location
#  resource_group_name = azurerm_resource_group.vmss.name

#  ip_configuration {
#    name                          = "IPConfiguration"
#    subnet_id                     = azurerm_subnet.vmss.id
#    private_ip_address_allocation = "dynamic"
#    public_ip_address_id          = azurerm_public_ip.jumpbox.id
#  }

#  tags = var.tags
# }

# resource "azurerm_virtual_machine" "jumpbox" {
#  name                  = "jumpbox"
#  location              = var.location
#  resource_group_name   = azurerm_resource_group.vmss.name
#  network_interface_ids = [azurerm_network_interface.jumpbox.id]
#  vm_size               = "Standard_DS1_v2"

#  storage_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = "16.04-LTS"
#    version   = "latest"
#  }

#  storage_os_disk {
#    name              = "jumpbox-osdisk"
#    caching           = "ReadWrite"
#    create_option     = "FromImage"
#    managed_disk_type = "Standard_LRS"
#  }

#  os_profile {
#    computer_name  = "jumpbox"
#    admin_username = var.admin_user
#    admin_password = var.admin_password
#  }

#  os_profile_linux_config {
#    disable_password_authentication = false
#  }

#  tags = var.tags
# }


