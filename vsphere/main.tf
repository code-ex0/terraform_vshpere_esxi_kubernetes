resource "vsphere_virtual_machine" "rancher" {
  name             = "controller"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 4096
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
          hostname         = "controller"
        })),
      "hostname" = "controller",
    }
  }
}
