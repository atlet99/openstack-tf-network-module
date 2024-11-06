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

########
# Router
########

variable "router" {
  description = "Information used to create and/or connect router to subnets"
  type = object({
    create                = bool
    name                  = optional(string, null)
    description           = optional(string, null)
    external_network_id   = string
    enable_snat           = optional(bool, null)
    force_destroy         = optional(bool, false)
  })
}

variable "region" {
  description = "Region where resources will be created"
  type        = string
}

#########
# Subnets
#########
variable "subnets" {
  description = "List of subnets"
  type        = list(any)
  default     = []
}

variable "router_tags" {
  description = "Tags for the router"
  type        = list(string)
  default     = []
}

variable "router_fixed_ips" {
  description = "List of external fixed IPs for the router"
  type = list(object({
    subnet_id  = string
    ip_address = string
  }))
  default = []
}
