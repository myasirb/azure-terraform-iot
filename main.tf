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
  account_replication_type = "RAGRS"
  min_tls_version          = "TLS1_2"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
  allow_nested_items_to_be_public = false
  
  tags = {
    environment = var.environment
  }
}

# Create a blob container for storing IoT data
resource "azurerm_storage_container" "iot_container" {
  name                  = var.container_name
  storage_account_id  = azurerm_storage_account.iot_storage.id
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
    name                       = var.end_point_name
    container_name             = azurerm_storage_container.iot_container.name
    connection_string          = azurerm_storage_account.iot_storage.primary_blob_connection_string
    file_name_format           = "{iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}.json"
    batch_frequency_in_seconds = 100
    max_chunk_size_in_bytes    = 104857600
    encoding                   = "JSON"
    resource_group_name = azurerm_resource_group.iot_rg.name
  }

  # Route for device messages to storage endpoint
  route {
    name           = var.route_name
    source         = "DeviceMessages"
    condition      = "true" # Route all messages to storage
    endpoint_names = [var.end_point_name]
    enabled        = true
  }
}
