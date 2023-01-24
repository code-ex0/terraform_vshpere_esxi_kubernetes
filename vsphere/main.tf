provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

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

resource "vsphere_virtual_machine" "master" {
  count = 1
  name             = "master-${count.index+1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 8192
  guest_id         = "ubuntu64Guest"
  hardware_version = "17"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = 50
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  vapp {
    properties = {
      "user-data" = base64encode(templatefile("${path.module}/templates/userdata.yaml",
        {
          username         = var.username
          encrypted_passwd = var.encrypted_passwd
          ssh_public_key   = var.ssh_public_key
          packages         = jsonencode(var.packages)
          hostname         = "master-${count.index+1}"
        })),
      "hostname" = "master-${count.index+1}",
    }
  }
}

resource "vsphere_virtual_machine" "worker" {
  depends_on = [vsphere_virtual_machine.master]
  count = 3
  name             = "${var.hostname_prefix}-${count.index+1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 8192
  guest_id         = "ubuntu64Guest"
  hardware_version = "17"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = 50
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  vapp {
    properties = {
      "user-data" = base64encode(templatefile("${path.module}/templates/userdata.yaml",
        {
          username         = var.username
          encrypted_passwd = var.encrypted_passwd
          ssh_public_key   = var.ssh_public_key
          packages         = jsonencode(var.packages)
        })),
      "hostname" = "${var.hostname_prefix}-${count.index+1}",
    }
  }
}

output "worker_ip" {
  value = vsphere_virtual_machine.worker.*.default_ip_address
}

output "worker_name" {
  value = vsphere_virtual_machine.worker.*.name
}