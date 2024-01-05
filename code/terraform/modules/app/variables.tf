# General variables
variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["int", "dev", "tst", "qa", "uat", "prp", "prd"], var.environment)
    error_message = "Please use an allowed value: \"int\", \"dev\", \"tst\", \"qa\", \"uat\", \"prp\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "resource_group_name" {
  description = "Specifies the resource group name in which all resources will get deployed."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.resource_group_name) >= 2
    error_message = "Please specify a valid resource group name."
  }
}

# Web App variables
variable "app_kind" {
  description = "Specifies the kind of the Azure Web App."
  type        = string
  sensitive   = false
  default     = "linux"
  validation {
    condition     = contains(["linux", "linux,function"], var.app_kind)
    error_message = "Please specify a valid runtime."
  }
}

variable "app_runtime" {
  description = "Specifies the code runtime of the Azure Web App."
  type        = string
  sensitive   = false
  default     = "Python"
  validation {
    condition     = contains(["Python", "node"], var.app_runtime)
    error_message = "Please specify a valid runtime."
  }
}

variable "app_runtime_version" {
  description = "Specifies the runtime version of the Azure Web App."
  type        = string
  sensitive   = false
  default     = "3.10"
  # validation {
  #   condition     = contains(["3.9", "3.10"], var.app_runtime_version)
  #   error_message = "Please specify a valid runtime version."
  # }
}

variable "app_health_path" {
  description = "Specifies the health endpoint of the Azure Web App."
  type        = string
  sensitive   = false
  validation {
    condition     = startswith(var.app_health_path, "/") || var.app_health_path == ""
    error_message = "Please specify a valid path."
  }
}

variable "app_settings" {
  description = "Specifies the custom app settings of the Azure Function. Baseline app settings are already defined."
  type = list(object(
    {
      name  = string,
      value = string
    }
  ))
  sensitive = false
  default   = []
}

variable "app_service_plan_id" {
  description = "Specifies the resource ID of the app service plan used for the Azure Function."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.app_service_plan_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

variable "log_analytics_workspace_id" {
  description = "Specifies the resource ID of the log analytics workspace used for collecting logs."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.log_analytics_workspace_id)) == 9
    error_message = "Please specify a valid resource ID."
  }
}

# Network variables
variable "app_subnet_id" {
  description = "Specifies the resource ID of the subnet used for the Azure Web App."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.app_subnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "app_allowed_service_tags" {
  description = "Specifies the allowed service tags for ingress for the Azure Web App."
  type = list(object({
    priority         = number
    service_tag_name = string
  }))
  sensitive = false
  default   = []
  validation {
    condition = alltrue([
      length([for allowed_service_tag in toset(var.app_allowed_service_tags) : allowed_service_tag if allowed_service_tag.priority <= 0 || allowed_service_tag.priority >= 2147483647]) <= 0
    ])
    error_message = "Please valid ip security restrictions."
  }
}

variable "private_endpoint_subnet_id" {
  description = "Specifies the resource ID of the subnet used for the private endpoints."
  type        = string
  sensitive   = false
  validation {
    condition     = length(split("/", var.private_endpoint_subnet_id)) == 11
    error_message = "Please specify a valid resource ID."
  }
}

variable "private_dns_zone_id_key_vault" {
  description = "Specifies the resource ID of the private DNS zone for Azure Key Vault. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_key_vault == "" || (length(split("/", var.private_dns_zone_id_key_vault)) == 9 && endswith(var.private_dns_zone_id_key_vault, "privatelink.vaultcore.azure.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_blob" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage blob endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_blob == "" || (length(split("/", var.private_dns_zone_id_blob)) == 9 && endswith(var.private_dns_zone_id_blob, "privatelink.blob.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_file" {
  description = "Specifies the resource ID of the private DNS zone for Azure Storage file endpoints. Not required if DNS A-records get created via Azure Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_file == "" || (length(split("/", var.private_dns_zone_id_file)) == 9 && endswith(var.private_dns_zone_id_file, "privatelink.file.core.windows.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

variable "private_dns_zone_id_sites" {
  description = "Specifies the resource ID of the private DNS zone for Azure Websites. Not required if DNS A-records get created via Azue Policy."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.private_dns_zone_id_sites == "" || (length(split("/", var.private_dns_zone_id_sites)) == 9 && endswith(var.private_dns_zone_id_sites, "privatelink.azurewebsites.net"))
    error_message = "Please specify a valid resource ID for the private DNS Zone."
  }
}

# Identity variables
variable "users_object_id" {
  description = "Specifies the object ID of the Azure AD group/Entra ID group."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.users_object_id) >= 2
    error_message = "Please specify a valid object ID."
  }
}

variable "sp_object_id" {
  description = "Specifies the object id of the operations AAD security group/operations user."
  type        = string
  sensitive   = false
  default     = ""
  validation {
    condition     = var.sp_object_id == "" || length(var.sp_object_id) >= 2
    error_message = "Please specify a valid object id."
  }
}
