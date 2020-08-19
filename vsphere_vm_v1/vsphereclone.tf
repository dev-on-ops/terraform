provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "Test1234!"
  vsphere_server = "vcsa01.dev.bertahome"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "vm" {
  for_each = var.hostname
  name             = "${each.value}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster[each.key].resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore[each.key].id}"

  num_cpus = lookup(var.cpu, each.key, 2)
  memory   = lookup(var.memory, each.key, 512)
  guest_id = "${data.vsphere_virtual_machine.template[each.key].guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template[each.key].scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network[each.key].id}"
    adapter_type = "${data.vsphere_virtual_machine.template[each.key].network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template[each.key].disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template[each.key].disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template[each.key].disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template[each.key].id}"

    customize {
      linux_options {
        host_name = "${each.value}"
        domain    = "dev.bertahome"
      }

      network_interface {
        ipv4_address = lookup(var.ipaddress, each.key, "192.168.255.0")
        ipv4_netmask = 24
      }

      ipv4_gateway = "192.168.255.2"
    }
  }
}