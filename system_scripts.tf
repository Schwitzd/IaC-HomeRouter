# Scripts - Locals
locals {
  scripts = {
    update_container_image = {
      name    = "update_container_image"
      url     = "https://gist.githubusercontent.com/Schwitzd/517b5ba2add1bcad9528dd5f37e0fdaf/raw/442eb3e214921952710afce3555ce2ed7f6cef62/mikrotik-UpdateContainerImage"
      comment = "This script repull existing containers image"
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
