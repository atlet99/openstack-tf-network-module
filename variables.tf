#########
# Network
#########
variable "create" {
  description = "Whether to create network and subnets"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of network"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix of network"
  type        = string
  default     = ""
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix before name or not"
  type        = bool
  default     = false
}

variable "description" {
  type        = string
  description = "Description of network"
  default     = "Managed by Terraform"
}

variable "admin_state_up" {
  type        = bool
  description = "The administrative state of the network"
  default     = null
}

variable "shared" {
  description = "Specifies whether the network is shared"
  type        = bool
  default     = false
}

variable "external" {
  description = "Specifies whether the network has external routing"
  type        = bool
  default     = false
}

variable "port_security_enabled" {
  description = "Whether to explicitly enable or disable port security on the network"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the network"
  type        = list(string)
  default     = []
}

########
# Router
########

variable "router" {
  description = "Information used to create and/or connect router to subnets"
  type = object({
    create           = bool
    name             = string
    description      = string
    external_network_id = string
    enable_snat      = bool
    external_network_name = string
    force_destroy    = bool
  })
  default = {
    create               = true
    name                 = null
    description          = null
    external_network_id  = null
    enable_snat          = null
    external_network_name = ""
    force_destroy        = false
  }
}


variable "region" {
  description = "Region where resources will be created"
  type        = string
  default     = "main"
}

#########
# Subnets
#########
variable "subnets" {
  description = "List of subnets"
  type        = list(any)
  default     = []
}

#########
# Security Group
#########
variable "secgroup_name" {
  description = "Name of the security group"
  type        = string
  default     = "default_secgroup"
}

variable "secgroup_description" {
  description = "Description of the security group"
  type        = string
  default     = "Default security group managed by Terraform"
}

variable "fixed_ip" {
  description = "Fixed IP address for the port"
  type        = map(string)
  default     = {
    ip_address = "192.168.199.10"
  }
}

variable "router_tags" {
  description = "Tags for the router"
  type        = list(string)
  default     = []
}

variable "router_fixed_ips" {
  description = "List of external fixed IPs for the router"
  type        = list(object({
    subnet_id  = string
    ip_address = string
  }))
  default     = []
}
