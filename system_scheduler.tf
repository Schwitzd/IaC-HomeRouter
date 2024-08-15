# Scheduler - Locals
locals {
  schedules = {
    update_container_image = {
      on_event   = local.scripts.update_container_image.name
      interval   = "1w"
      start_date = "aug/18/2024"
      start_time = "09:00:00"
      policy     = ["read", "write", "policy"]
    }
  }
}

# Scheduler
resource "routeros_system_scheduler" "schedules" {
  for_each = local.schedules

  name       = each.key
  on_event   = each.value.on_event
  interval   = each.value.interval
  start_date = each.value.start_date
  start_time = each.value.start_time
  policy     = each.value.policy
}
