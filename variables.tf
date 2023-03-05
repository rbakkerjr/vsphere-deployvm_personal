# Info about the vSphere environment. Input for these should bein the terraform.tfvars file
variable "username" {}
variable "password" {}
variable "vcenter" {}
variable "dc" {}
variable "vsphere_cluster" {}
variable "vsphere_rp" {}
variable "vsphere_datastore" {}
variable "vsphere_network_mgmt" {}
variable "vsphere_network_mine" {}

# This will be for information about the VMs created under this plan
variable "folder_name" {  
  default = "TerraformTest"
}

# Variables for VM creation
variable "vm_cpus" {
  type = number
  default = 2
}

variable "vm_memory" {
  # This is in MB
  type = number
  default = 4096
}

variable "vm_disksize" {
  # This is in GB
  default = 64
}

variable "vm_name" {
  default = "ubuntuterraform"
}

variable "templatename" {
  default = "ubuntu-2204-server-cloudimg-amd64"
}