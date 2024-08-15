# Scripts - Locals
locals {
  scripts = {
    update_container_image = {
      name    = "update_container_image"
      url     = "https://gist.githubusercontent.com/Schwitzd/517b5ba2add1bcad9528dd5f37e0fdaf/raw/905fbe0d4d68a519a79b83a07b792ff7b5d88a83/mikrotik-UpdateContainerImage"
      comment = "This script updates the container image"
      policy  = ["read", "write", "policy"]
    }
  }
}

# Scripts- Raw code
data "http" "scripts" {
  for_each = local.scripts

  url = each.value.url
}

# Scripts
resource "routeros_system_script" "scripts" {
  for_each = local.scripts

  name    = each.value.name
  comment = each.value.comment
  policy  = each.value.policy
  source  = data.http.scripts[each.key].body
}
