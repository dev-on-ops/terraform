data "vsphere_datacenter" "dc" {
  for_each = var.hostname
  name          = lookup(var.datacenter, each.key, "fail")
//  name = "testdc"
}

data "vsphere_datastore" "datastore" {
  for_each = var.hostname
  name          = lookup(var.datastore, each.key, "fail")
//  name          = "ds1"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}

data "vsphere_compute_cluster" "cluster" {
  for_each = var.hostname
  name          = lookup(var.cluster, each.key, "fail")
//  name          = "testcluster"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}

data "vsphere_network" "network" {
  for_each = var.hostname
  name          = lookup(var.vmnetwork, each.key, "fail")
//  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}

data "vsphere_virtual_machine" "template" {
  for_each = var.hostname
  name          = lookup(var.template, each.key, "fail")
//  name          = "ubuntutmpl"
  datacenter_id = "${data.vsphere_datacenter.dc[each.key].id}"
}
