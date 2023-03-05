terraform {
  required_providers {
    vsphere = {
        source = "hashicorp/vsphere"
        version = ">=2.0"
    }
  }
}

provider "vsphere" {
  user = var.username
  password = var.password
  vsphere_server = var.vcenter
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.dc
}

data "vsphere_compute_cluster" "cluster" {
  name = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "default" {
  name = "${var.vsphere_cluster}/Resources/"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "vsan" {
  name = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "mgmt_network" {
  name = var.vsphere_network_mgmt
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "personal_network" {
  name = var.vsphere_network_mine
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_folder" "dev_folder" {
  path = var.folder_name
}

data "vsphere_virtual_machine" "template" {
  name = "${var.templatename}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name = "${var.vm_name}"
  num_cpus = var.vm_cpus
  memory = var.vm_memory
  datastore_id = data.vsphere_datastore.vsan.id
  resource_pool_id = data.vsphere_resource_pool.default.id
  folder = data.vsphere_folder.dev_folder.path
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id = data.vsphere_network.mgmt_network.id
  }

  disk {
    label = "${var.templatename}_disk0"
    size = "${var.vm_disksize}"
    thin_provisioned = true
  }

  cdrom {
    client_device = true
  }
  
  # Template to use
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
  # Cloud-init data
  vapp {
    properties = {
      user-data = "${base64encode(file("cloud-init.yml"))}"
    }
  }  
}