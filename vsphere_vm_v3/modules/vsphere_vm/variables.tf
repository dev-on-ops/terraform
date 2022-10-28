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
        dns_servers      = list(string)
        dns_search      = list(string)
        os_disk_size    = number
        cloud_init_file = string
        additionaldisks = list(object({label = string, size = number, thin_provisioned = bool, index = number}))
        cpu             = number
        ram             = number 
        tags            = list(string)
      }))
      default = {}
    }

variable "additionaldisks" {
  type = list(object({
    label = string
    size = number
    then_provisioned = bool
  }))
  default = []
}