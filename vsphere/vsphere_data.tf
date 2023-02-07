data "vsphere_datacenter" "datacenter" {
  name = "gypaetus"
}

data "vsphere_datastore" "datastore" {
  name          = "nas"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "nuc"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "jammy-server-cloudimg-amd64"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}