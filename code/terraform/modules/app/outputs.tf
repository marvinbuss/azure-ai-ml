output "app_resource_id" {
  description = "Specifies the resource id of the app."
  value       = azapi_resource.app.id
  sensitive   = false
}

output "app_name" {
  description = "Specifies the name of the app."
  value       = azapi_resource.app.name
  sensitive   = false
}
