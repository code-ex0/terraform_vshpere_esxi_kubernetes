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

variable "username" {
  type = string
}

variable "encrypted_passwd" {
  type = string
  sensitive   = true
}

variable "ssh_public_key" {
  type = string
}

variable "packages" {
    type = list(string)
}

variable "hostname_prefix" {
    type = string
}

