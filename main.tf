
provider "azurerm" {
  version = "1.38.0"
  subscription_id = var.sub_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = "East US 2"
}

resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = false
#   The below param is only available with the "Premium" sku.
#   georeplication_locations = ["West US", "East US"]
}

resource "azurerm_kubernetes_cluster" "kube_clust" {
  name                = var.kube_clust_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.kube_clust_name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS1_v2"
  }

  service_principal {
    client_id     = var.app_id
    client_secret = var.app_secret
  }

  addon_profile {
      http_application_routing {
          enabled = true
        }
  }

  tags = {
    purpose = "limesurvey"
  }
}
