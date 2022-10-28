provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "Test1234!"
  vsphere_server = "vcsa01.lab.bertahome"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "vms" {
  for_each = var.hostname
  name             = each.value.hostname
  resource_pool_id = data.vsphere_compute_cluster.cluster[each.key].resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore[each.key].id

  num_cpus = each.value.cpu
  memory   = each.value.ram
  guest_id = data.vsphere_virtual_machine.template[each.key].guest_id
  scsi_type = data.vsphere_virtual_machine.template[each.key].scsi_type

  network_interface {
    network_id   = data.vsphere_network.network[each.key].id
    adapter_type = data.vsphere_virtual_machine.template[each.key].network_interface_types[0]
  }

  disk {
    label            = "${each.value.hostname}-disk0"
    size             = each.value.os_disk_size
 //   size             = "${data.vsphere_virtual_machine.template[each.key].disks.0.size}"
    eagerly_scrub    = data.vsphere_virtual_machine.template[each.key].disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template[each.key].disks.0.thin_provisioned
  }

  dynamic "disk" {
    for_each = [for disk in each.value.additionaldisks: {
      disk_size_gb = disk.size
      disk_index = disk.index
      disk_thin = disk.thin_provisioned
      disk_label = disk.label
    }]
    content {
      unit_number = disk.value.disk_index
      datastore_id = data.vsphere_datastore.datastore[each.key].id
      label            = disk.value.disk_label
      size             = disk.value.disk_size_gb
      thin_provisioned = disk.value.disk_thin
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.key].id

    customize {
      linux_options {
        host_name = each.value.hostname
        domain    = each.value.domain
      }

      network_interface {
        ipv4_address = each.value.ipv4_address
        ipv4_netmask = each.value.ipv4_netmask
      }

      ipv4_gateway = each.value.ipv4_gateway
    }
  }
  extra_config = {
    "guestinfo.metadata"          = base64encode(data.template_file.cloud-init-metadata.rendered)
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(data.template_file.cloud-init-userdata.rendered)
    "guestinfo.userdata.encoding" = "base64"
  }
}