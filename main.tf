##############################################################################
# Require terraform 0.9.3 or greater
##############################################################################
terraform {
  required_version = ">= 0.9.3"
}
##############################################################################
# IBM Cloud Provider
##############################################################################
# See the README for details on ways to supply these values
provider "ibm" {
  bluemix_api_key = "${var.bxapikey}"
  softlayer_username = "${var.slusername}"
  softlayer_api_key = "${var.slapikey}"
}

##############################################################################
# IBM SSH Key: For connecting to VMs - Creating a new ssh key
##############################################################################
#resource "ibm_compute_ssh_key" "ssh_key" {
#  label = "${var.key_label}"
#  notes = "${var.key_note}"
#  # Public key, so this is completely safe
#  public_key = "${var.public_key}"
#}
##############################################################################
# IBM SSH Key: For connecting to VMs - Import an existing ssh key
##############################################################################
data "ibm_infra_ssh_key" "public_key" {
    label = "Patricks Public Key"
}
# https://ibm-bluemix.github.io/tf-ibm-docs/v0.3-tf-v0.9.3/d/infra_ssh_key.html

##############################################################################
# Variables
##############################################################################
variable bxapikey {
  description = "Your Bluemix API Key."
}
variable slusername {
  description = "Your Softlayer username."
}
variable slapikey {
  description = "Your Softlayer API Key."
}
variable datacenter {
  description = "The datacenter to create resources in."
}
#variable public_key {
#  description = "Your public SSH key material."
#}
#variable key_label {
#  description = "A label for the SSH key that gets created."
#}
#variable key_note {
#  description = "A note for the SSH key that gets created."
#}
variable hostname {
  description = "Hostname of instance"
}

##############################################################################
# Compute Instance
##############################################################################
resource "ibm_infra_virtual_guest" "centos_small_virtual_guest" {
  name = "${var.hostname}",
  image = "CentOS_7_64"
  domain = "schematics.ibm.com",
  region = "${var.datacenter}",
  public_network_speed = 10,
  hourly_billing = true,
  private_network_only = false,
  cpu = 1,
  ram = 1024,
  disks = [
      "25",
      "10",
      "20"
  ],
  user_data = "{\\\"value\\\":\\\"newvalue\\\"}",
  dedicated_acct_host_only = true,
  local_disk = false,
  ssh_keys = [
      "${data.ibm_infra_ssh_key.public_key.id}"
  ]
}
  
  
  
##############################################################################
# Outputs
##############################################################################
#output "ssh_key_id" {
#  value = "${ibm_compute_ssh_key.ssh_key.id}"
#}
