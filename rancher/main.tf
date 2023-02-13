resource "rancher2_cloud_credential" "vsphere-terraform" {
  name = "vsphere-terraform"
  description = "Terraform Credentials"
  vsphere_credential_config {
    username = var.vsphere_user
    password = var.vsphere_password
    vcenter = var.vsphere_server
  }
}

resource "rancher2_node_template" "vSphereTestTemplate" {
  name = "vSphereTestTemplate"
  description = "Created by Terraform"
  cloud_credential_id = rancher2_cloud_credential.vsphere-terraform.id
  vsphere_config {
    datacenter = "/gypaetus"
    datastore = "/gypaetus/datastore/nas"
    folder = "/gypaetus/vm"
    pool = "/gypaetus/host/nuc/Resources"
    cpu_count = "4"
    memory_size = "8192"
    disk_size = "20000"
    network = [
      "/gypaetus/network/VM Network"
    ]
    cfgparam = [
      "disk.enableUUID=TRUE"
    ]
    boot2docker_url = "https://releases.rancher.com/os/latest/rancheros-vmware.iso"
  }
  engine_install_url = "https://releases.rancher.com/install-docker/20.10.sh"
}

resource "rancher2_cluster" "vsphere" {
  name = "gypaetus-"
  description = "Terraform created clustervSphere Cluster"
  rke_config {
    network {
      plugin = "canal"
    }
  }
}

resource "rancher2_node_pool" "master" {

  cluster_id =  rancher2_cluster.vsphere.id
  hostname_prefix =  "master-"
  node_template_id = rancher2_node_template.vSphereTestTemplate.id
  quantity = 1
  control_plane = true
  etcd = true
  worker = true
  name = "master"
}

resource "rancher2_node_pool" "worker" {
  cluster_id =  rancher2_cluster.vsphere.id
  hostname_prefix =  "worker-"
  node_template_id = rancher2_node_template.vSphereTestTemplate.id
  quantity = 2
  control_plane = false
  etcd = false
  worker = true
  name = "worker"
}
