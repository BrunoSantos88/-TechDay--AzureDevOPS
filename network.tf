resource "azurerm_virtual_network" "mynetwork" {
  name                = "mynetwork"
  address_space       = ["192.1.0.0/16"]
  location            = "eastus"
  resource_group_name = "devops"
}


resource "azurerm_subnet" "mysubnet" {
  name                 = "internal"
  resource_group_name = "devops"
  virtual_network_name = azurerm_virtual_network.mynetwork.name
  address_prefixes     = ["192.1.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = "eastus"
  resource_group_name = "devops"



  ip_configuration {
    name                          = "frontend"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend_ip.id

  }
}

resource "azurerm_public_ip" "frontend_ip" {
  name                = "vm_frontend_ip"
  location            = "eastus"
  resource_group_name = "devops"
  allocation_method   = "Dynamic"
}






