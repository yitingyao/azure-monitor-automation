
output "resource_group_name" {
  value = azurerm_resource_group.monitoring_rg.name
}

output "log_analytics_workspace" {
  value = azurerm_log_analytics_workspace.logs.name
}

output "vm_name" {
  value = azurerm_virtual_machine.vm.name
}
