variable "vsphere_user" {
  default = "root"
  type = string
  description = "username for vcenter"
}

variable "vsphere_password" {
  default = "password"
  type = string
  description = "password for vcenter"
  sensitive   = true
}

variable "vsphere_server" {
  default = "vcenter"
  type = string
  description = "vcenter server"
}

variable "rancher_server" {
  default = "rancher"
  type = string
  description = "vcenter server"
}

variable "rancher_access_key" {
  default = "vcenter"
  type = string
  description = "access key"
  sensitive   = true
}

variable "rancher_secret_key" {
  default = "vcenter"
  type = string
  description = "secret key"
  sensitive   = true
}