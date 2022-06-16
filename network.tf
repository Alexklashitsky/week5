# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/24"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# # # # #create subnets

#publice 
resource "azurerm_subnet" "public" {
  name                 = "public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.0.0/26"]
}
#privete
resource "azurerm_subnet" "privete" {
  name                 = "privete"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.0.88/29"]
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}
# Create public IPs
resource "azurerm_public_ip" "publicIpApp" {
  name                = "appServerPublicIp"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

}
# resource "azurerm_public_ip" "publicIpDB" {
#   name                = "DBServerPublicIp"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
# }


resource "azurerm_public_ip" "publicIpLB" {
  name                = "LBServerPublicIp"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = random_string.fqdn.result

}

resource "random_string" "fqdn" {
  length  = 6
  special = false
  upper   = false
  number  = false
}




# # Create Network Security Groups and rule

#public
resource "azurerm_network_security_group" "public_nsg" {
  name                = "public_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "anyany"
    priority                   = 250
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 280
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "outsideweb"
    priority                   = 290
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
#privete
resource "azurerm_network_security_group" "privete_nsg" {
  name                = "privete_nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 280
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "postgareSQL"
    priority                   = 290
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.0.0/26"
    destination_address_prefix = "*"
  }
}

# # # # Create network interface

#app server
resource "azurerm_network_interface" "appNic" {
  name                = "appNic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "appNic"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.4"
    public_ip_address_id          = azurerm_public_ip.publicIpApp.id

  }
}


# #dbserver

# resource "azurerm_network_interface" "dbNic" {
#   name                = "dbNic"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   ip_configuration {
#     name                          = "dbNic"
#     subnet_id                     = azurerm_subnet.privete.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.publicIpDB.id
#   }
# }

# # Connect the security group to the network subnets
# resource "azurerm_subnet_network_security_group_association" "public" {
#   subnet_id                 = azurerm_subnet.public.id
#   network_security_group_id = azurerm_network_security_group.public_nsg.id
# }
# resource "azurerm_subnet_network_security_group_association" "privete" {
#   subnet_id                 = azurerm_subnet.privete.id
#   network_security_group_id = azurerm_network_security_group.privete_nsg.id
# }


# #LB
resource "azurerm_lb" "LB" {
  name                = "LoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicIpLB.id
  }
}

resource "azurerm_lb_backend_address_pool" "backendPool" {

  name            = "BackEndAddressPool"
  loadbalancer_id = azurerm_lb.LB.id

}


resource "azurerm_lb_probe" "LB" {
  #   resource_group_name = "week5"
  loadbalancer_id = azurerm_lb.LB.id
  name            = "ssh-running-probe"
  port            = "8080"
}

resource "azurerm_lb_rule" "lbnatrule" {
  #   resource_group_name = var.resource_group_name
  loadbalancer_id                = azurerm_lb.LB.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backendPool.id]
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.LB.id
  disable_outbound_snat          = true
}

# # # # # # # resource "azurerm_lb_nat_rule" "nat" {
# # # # # # #   resource_group_name            = var.resource_group_name
# # # # # # #   loadbalancer_id                = azurerm_lb.LB.id
# # # # # # #   name                           = "webAccess"
# # # # # # #   protocol                       = "Tcp"
# # # # # # #   frontend_port                  = 8080
# # # # # # #   backend_port                   = 8080
# # # # # # #   frontend_ip_configuration_name = "PublicIPAddress"
# # # # # # # }

resource "azurerm_lb_outbound_rule" "outRule" {
  loadbalancer_id         = azurerm_lb.LB.id
  name                    = "OutboundRule"
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendPool.id

  frontend_ip_configuration {
    name = "PublicIPAddress"


  }
}

# # # privte DNS

resource "azurerm_private_dns_zone" "dns" {
  name                = "tracker.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "dns_link"
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = var.resource_group_name
}




