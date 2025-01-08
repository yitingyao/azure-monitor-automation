# Resource Group
resource "azurerm_resource_group" "monitoring_rg" {
  name     = "monitoring-rg"
  location = "East US"
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "monitoring-logs"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  sku                 = "PerGB2018"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "monitoring-vnet"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "monitoring-subnet"
  resource_group_name  = azurerm_resource_group.monitoring_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "test-vm-nic"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name

  ip_configuration {
    name                          = "test-vm-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "test-vm"
  location              = azurerm_resource_group.monitoring_rg.location
  resource_group_name   = azurerm_resource_group.monitoring_rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = "testvm"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Monitor Alert for High CPU
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "high-cpu-alert"
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  scopes              = [azurerm_virtual_machine.vm.id]
  description         = "Alert when CPU usage exceeds 85%"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 85
  }
}
