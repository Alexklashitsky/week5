# create storage account

resource "azurerm_storage_account" "storage" {
  name                     = "backendstorage2022"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}


# create storage container

resource "azurerm_storage_container" "backendstate" {
  name                  = "state"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
