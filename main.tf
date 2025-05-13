resource "azurerm_resource_group" "iot_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a storage account for storing IoT data 
resource "azurerm_storage_account" "iot_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.iot_rg.name
  location                 = azurerm_resource_group.iot_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = var.environment
  }
}

# Create a blob container for storing IoT data
resource "azurerm_storage_container" "iot_container" {
  name                  = "iotdata"
  storage_account_name  = azurerm_storage_account.iot_storage.name
  container_access_type = "private"
}

resource "azurerm_iothub" "iot_hub" {
  name                = var.iot_hub_name
  location            = azurerm_resource_group.iot_rg.location
  resource_group_name = azurerm_resource_group.iot_rg.name

  sku {
    name     = "S1"
    capacity = 1
  }

  tags = {
    environment = var.environment
  }

  # Define the storage endpoint directly in the IoT Hub resource
  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    name                       = "storage"
    container_name             = azurerm_storage_container.iot_container.name
    connection_string          = azurerm_storage_account.iot_storage.primary_blob_connection_string
    file_name_format           = "{iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    encoding                   = "JSON"
  }
  # Route for device messages to storage endpoint
  route {
    name           = "storage-route"
    source         = "DeviceMessages"
    condition      = "true" # Route all messages to storage
    endpoint_names = ["storage"]
    enabled        = true
  }

  # Route for device messages to built-in events endpoint (default)
  route {
    name           = "events-route"
    source         = "DeviceMessages"
    condition      = "true" # Route all messages to events endpoint
    endpoint_names = ["events"]
    enabled        = true
  }
}
