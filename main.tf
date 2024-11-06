resource "random_id" "this" {
  count       = var.create && var.use_name_prefix && var.name_prefix == "" ? 1 : 0
  byte_length = 8
}

locals {
  this_net_id   = var.create && length(openstack_networking_network_v2.this) > 0 ? openstack_networking_network_v2.this[0].id : ""
  this_net_name = var.use_name_prefix ? (var.name_prefix == "" ? "${random_id.this[0].hex}-${var.name}" : "${var.name_prefix}-${var.name}") : var.name
}

resource "openstack_networking_network_v2" "this" {
  count          = var.create && false == var.use_name_prefix ? 1 : 0
  name           = local.this_net_name
  description    = var.description
  admin_state_up = var.admin_state_up
}

resource "openstack_networking_subnet_v2" "this" {
  count      = var.create ? length(var.subnets) : 0
  network_id = local.this_net_id
  name = lookup(var.subnets[count.index], "name", format(
    "%s-subnet-ipv%s-%s",
    local.this_net_name,
    lookup(var.subnets[count.index], "ip_version", 4),
    count.index + 1
  ))
  description     = lookup(var.subnets[count.index], "description", null)
  cidr            = lookup(var.subnets[count.index], "cidr", null)
  ip_version      = lookup(var.subnets[count.index], "ip_version", null)
  dns_nameservers = lookup(var.subnets[count.index], "dns_nameservers", null)
  enable_dhcp     = lookup(var.subnets[count.index], "enable_dhcp", null)
  gateway_ip      = lookup(var.subnets[count.index], "gateway_ip", null)
  no_gateway      = lookup(var.subnets[count.index], "no_gateway", null)
}

resource "openstack_networking_router_v2" "this" {
  count               = var.router.create ? 1 : 0
  name                = lookup(var.router, "name", null)
  admin_state_up      = lookup(var.router, "admin_state_up", true)
  description         = lookup(var.router, "description", null)
  external_network_id = var.router.external_network_id
  enable_snat         = lookup(var.router, "enable_snat", null)
  region              = var.region != "" ? var.region : null
  tags                = var.router_tags != [] ? var.router_tags : null

  dynamic "external_fixed_ip" {
    for_each = var.router_fixed_ips
    content {
      subnet_id  = external_fixed_ip.value.subnet_id
      ip_address = external_fixed_ip.value.ip_address
    }
  }
}

locals {
  router_id_indexes = [for e in var.subnets : index(var.subnets, e) if lookup(e, "router_id", null) != null && lookup(e, "router_id", null) != ""]
  routes_indexes    = [for e in var.subnets : index(var.subnets, e) if lookup(e, "routes", "") != ""]
  routes            = flatten([for e in local.routes_indexes : [for r in var.subnets[e].routes : merge(r, { subnet_index = e })]])
}

resource "openstack_networking_router_interface_v2" "this_router_id" {
  count = var.create ? length(local.router_id_indexes) : 0

  router_id = (var.subnets[local.router_id_indexes[count.index]].router_id == "@self"
    ? openstack_networking_router_v2.this[0].id
    : var.subnets[local.router_id_indexes[count.index]].router_id
  )

  subnet_id     = openstack_networking_subnet_v2.this[local.router_id_indexes[count.index]].id
  region        = var.region != "" ? var.region : null
  force_destroy = lookup(var.router, "force_destroy", false)
}

resource "openstack_networking_subnet_route_v2" "this" {
  count            = var.create ? length(local.routes) : 0
  subnet_id        = openstack_networking_subnet_v2.this[local.routes[count.index].subnet_index].id
  destination_cidr = local.routes[count.index].destination_cidr
  next_hop         = local.routes[count.index].next_hop
  region           = var.region
}
