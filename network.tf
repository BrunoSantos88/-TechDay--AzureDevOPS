resource "azurerm_virtual_network" "mynetwork" {
  name                = "mynetwork"
  address_space       = ["192.1.0.0/16"]
  location            = var.resource_group_name_location
  resource_group_name = var.resource_group_name_group
}

resource "azurerm_subnet" "mysubnet" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name_group
  virtual_network_name = azurerm_virtual_network.mynetwork.name
  address_prefixes     = ["192.1.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_interface" "frontend" {
  name                = "frontend-nic"
  location            = var.resource_group_name_location
  resource_group_name = var.resource_group_name_group



  ip_configuration {
    name                          = "frontend"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend_ip.id

  }
}

resource "azurerm_public_ip" "frontend_ip" {
  name                = "vm_frontend_ip"
  resource_group_name = var.resource_group_name_group
  location            = var.resource_group_name_location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "backend" {
  name                = "backend-nic"
  location            = var.resource_group_name_location
  resource_group_name = var.resource_group_name_group


  ip_configuration {
    name                          = "backend"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.backend_ip.id
  }
}

resource "azurerm_public_ip" "backend_ip" {
  name                = "vm_backend_ip"
  resource_group_name = var.resource_group_name_group
  location            = var.resource_group_name_location
  allocation_method   = "Dynamic"
}




