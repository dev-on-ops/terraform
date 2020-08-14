variable "hostname" {
    type = map(object({
        hostname        = string
        datacenter      = string
        datastore       = string
        cluster         = string
        network         = string
        template        = string
        domain          = string
        ipv4_address    = string
        ipv4_netmask    = number
        ipv4_gateway    = string
        os_disk_size    = number
        cpu             = number
        ram             = number 
        tags            = list(string)
      }))
      default = {}
    }

#variable "hostname" {
#    type    = "map"
#    default = {
#    vm1 = "testserver1"
#    vm2 = "testserver2"
#    vm3 = "testserver3"
#    }
#}
/*
variable "cpu" {
    type    = "map"
    default = {
    vm1 = "1"
    vm2 = "1"
    vm3 = "1"
    }
}

variable "memory" {
    type    = "map"
    default = {
    vm1 = "1024"
    vm2 = "1024"
    vm3 = "1024"
    }
}

variable "ipaddress" {
    type    = "map"
    default = {
    vm1 = "192.168.255.30"
    vm2 = "192.168.255.31"
    vm3 = "192.168.255.32"
    }
}

variable "cluster" {
    type    = "map"
    default = {
    vm1 = "testcluster"
    vm2 = "testcluster"
    vm3 = "testcluster"
    }
}
variable "datastore" {
    type    = "map"
    default = {
    vm1 = "ds1"
    vm2 = "ds1"
    vm3 = "ds1"
    }
}
variable "vmnetwork" {
    type    = "map"
    default = {
    vm1 = "VM Network"
    vm2 = "VM Network"
    vm3 = "VM Network"
    }
}
variable "datacenter" {
    type    = "map"
    default = {
    vm1 = "testdc"
    vm2 = "testdc"
    vm3 = "testdc"
    }
}
variable "template" {
    type    = "map"
    default = {
    vm1 = "ubuntutmpl"
    vm2 = "ubuntutmpl"
    vm3 = "ubuntutmpl"
    }
}
*/
variable "additionaldisks" {
  type = list(object({
    label = string
    size = number
    then_provisioned = bool
  }))
  default = []
}