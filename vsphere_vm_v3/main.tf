module "vm" {
    source = "./modules/vsphere_vm"
    hostname = var.hostname
}
