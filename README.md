# Azure IoT Hub Terraform Configuration

This Terraform configuration creates an Azure IoT Hub and related resources.

## Setup Instructions

### 1. Azure Service Principal

Before running Terraform, you need to create an Azure Service Principal:

```powershell
# Login to Azure
az login

# Get your subscription ID
az account show --query id -o tsv

# Create a service principal with Contributor role
az ad sp create-for-rbac --name "TerraformServicePrincipal" --role="Contributor" --scopes="/subscriptions/YOUR-SUBSCRIPTION-ID"
```

The command will output JSON with your credentials:
```json
{
  "appId": "00000000-0000-0000-0000-000000000000",       # This is your CLIENT_ID
  "displayName": "TerraformServicePrincipal",
  "password": "random-password",                        # This is your CLIENT_SECRET
  "tenant": "00000000-0000-0000-0000-000000000000"      # This is your TENANT_ID
}
```

### 2. Configure Service Principal Credentials

Edit the `terraform.tfvars` file with your actual service principal credentials:

```hcl
subscription_id = "your-subscription-id"
client_id       = "your-client-id"
client_secret   = "your-client-secret"
tenant_id       = "your-tenant-id"
```

### 3. Initialize and Apply Terraform

```powershell
# Initialize Terraform
terraform init

# See the execution plan
terraform plan

# Apply the configuration
terraform apply
```

## Project Structure

- `main.tf` - Main resource definitions
- `provider.tf` - Provider configuration with authentication
- `variables.tf` - Variable definitions
- `terraform.tfvars` - Variable values (including Service Principal credentials)
- `outputs.tf` - Output definitions

## Security Notes

- For production environments, consider using a `.gitignore` file to exclude `terraform.tfvars` from version control
- Alternatively, you can use a `terraform.tfvars.example` file in version control with placeholder values and keep the actual `terraform.tfvars` file local
- You can also consider using environment variables, Azure Key Vault, or Terraform Cloud for more secure credential management
