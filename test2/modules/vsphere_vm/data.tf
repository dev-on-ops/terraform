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
