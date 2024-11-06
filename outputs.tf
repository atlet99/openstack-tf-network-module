output "network_id" {
  value = try(openstack_networking_network_v2.this[*].id[0], null)
}

output "router_id" {
  value = try(openstack_networking_router_v2.this[*].id[0], null)
}

output "subnets" {
  value = try([for subnet in openstack_networking_subnet_v2.this : {
    id   = subnet.id
    name = subnet.name
    cidr = subnet.cidr
  }], [])
}
