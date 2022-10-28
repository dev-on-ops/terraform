data "vsphere_datacenter" "dc" {
  for_each = var.hostname
  name          = "${each.value.datacenter}"
//  name = "testdc"
}

data "vsphere_datastore" "datastore" {
  for_each = var.hostname
  name          = "${each.value.datastore}"
//  name          = "ds1"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}

data "vsphere_compute_cluster" "cluster" {
  for_each = var.hostname
  name          = "${each.value.cluster}"
//  name          = "testcluster"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}

data "vsphere_network" "network" {
  for_each = var.hostname
  name          = "${each.value.network}"
//  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}

data "vsphere_virtual_machine" "template" {
  for_each = var.hostname
  name          = "${each.value.template}"
//  name          = "ubuntutmpl"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}

data "template_file" "cloud-init-userdata" {
  for_each = var.hostname
  template = each.vaule.cloud_init_file != "null" ? file(each.value.cloud_init_file) : file("${path.module}/default_userdata.yml")
}

data "template_file" "cloud-init-metadata" {
  for_each = var.hostname
  template = file("${path.module}/metadata.yml")
    vars = {
      ipv4_address = "${each.value.ipv4_address}",
      ipv4_gateway = "${each.value.ipv4_gateway}",
      ipv4_netmask = "${each.value.ipv4_netmask}",
      dns_servers  = "${each.value.dns_servers}",
      dns_search   = "${each.value.dns_search}",
      hostname    = "${each.value.hostname}"
  }
}