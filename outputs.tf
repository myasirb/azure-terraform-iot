output "iothub_hostname" {
  value = azurerm_iothub.iot_hub.hostname
}

output "storage_account_name" {
  value = azurerm_storage_account.iot_storage.name
}

output "storage_container_url" {
  value = "https://${azurerm_storage_account.iot_storage.name}.blob.core.windows.net/${azurerm_storage_container.iot_container.name}"
  sensitive = true
}

output "iot_data_path_format" {
  value = "iotdata/{iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}"
  description = "Format of the path where data will be stored in the blob container"
}

output "iot_storage_endpoint" {
  value = "storage"
  description = "Name of the IoT Hub storage endpoint"
}