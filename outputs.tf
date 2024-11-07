output "network_id" {
  value = length(openstack_networking_network_v2.this) > 0 ? openstack_networking_network_v2.this[0].id : null
}

output "router_id" {
  value = length(openstack_networking_router_v2.this) > 0 ? openstack_networking_router_v2.this[0].id : null
}

output "subnets" {
  value = [for subnet in openstack_networking_subnet_v2.this : {
    id   = subnet.id
    name = subnet.name
    cidr = subnet.cidr
  }]
}
