variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
}

variable "iot_hub_name" {
  description = "The name of the IoT Hub. Must contain only alphanumeric characters and hyphens. Cannot start or end with a hyphen."
  type        = string
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "storage_account_name" {
  description = "The name of the storage account for storing IoT data. Must be between 3 and 24 characters in length and may contain numbers and lowercase letters only."
  type        = string
}

variable "container_name" {
  description = "The name of the blob storage in the container. Must be between 3 and 24 characters in length and may contain numbers and lowercase letters only."
  type        = string
}


variable "end_point_name" {
  description = "The name of the IoT Hub endpoint. Used to define where the messages from devices will be sent."
  type        = string
}

variable "route_name" {
  description = "The name of the IoT Hub message routing rule. It identifies the route to direct device messages to specific endpoints."
  type        = string
}

# Azure Service Principal Variables (populated from tfvars)
variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "client_id" {
  description = "The Azure Service Principal client ID"
  type        = string
}

variable "client_secret" {
  description = "The Azure Service Principal client secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Azure Tenant ID"
  type        = string
}
