# Azure RBAC Module - Main Configuration

locals {
  # Flatten the role assignments for iteration
  role_assignments = flatten([
    for principal in var.principals : [
      for role in var.roles : [
        for resource in var.resources : {
          principal_id   = principal.id
          principal_type = principal.type
          role_id       = role
          resource_id   = resource
        }
      ]
    ]
  ])
}

# Create role assignments
resource "azurerm_role_assignment" "role_assignments" {
  for_each = { for idx, assignment in local.role_assignments : "${assignment.principal_id}-${assignment.role_id}-${assignment.resource_id}" => assignment }

  principal_id         = each.value.principal_id
  role_definition_id   = each.value.role_id
  scope               = each.value.resource_id

  lifecycle {
    ignore_changes = [
      principal_id,
      role_definition_id,
      scope
    ]
  }
}