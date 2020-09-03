hostname = {
    "vault01" = {
        hostname        = "vault01",
        datacenter      = "home",
        datastore       = "vsanDatastore",
        cluster         = "lab",
        network         = "10.0.10.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.10.51",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.10.1",
        os_disk_size    = 40,
        additionaldisks = [{
                            label = "test1disk1", 
                            size = 40, 
                            thin_provisioned = true, 
                            index = 2,
                            }],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    },
    "vault02" = {
        hostname        = "vault02",
        datacenter      = "home",
        datastore       = "vsanDatastore",
        cluster         = "lab",
        network         = "10.0.10.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.10.52",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.10.1",
        os_disk_size    = 40,
        additionaldisks = [{
                            label = "test1disk1", 
                            size = 40, 
                            thin_provisioned = true, 
                            index = 2,
                            }],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    },
    "vault03" = {
        hostname        = "vault03",
        datacenter      = "home",
        datastore       = "vsanDatastore",
        cluster         = "lab",
        network         = "10.0.10.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.10.53",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.10.1",
        os_disk_size    = 40,
        additionaldisks = [{
                            label = "test1disk1", 
                            size = 40, 
                            thin_provisioned = true, 
                            index = 2,
                            }],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    },
    "vault04" = {
        hostname        = "vault04",
        datacenter      = "home",
        datastore       = "vsanDatastore",
        cluster         = "lab",
        network         = "10.0.10.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.10.54",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.10.1",
        os_disk_size    = 40,
        additionaldisks = [{
                            label = "test1disk1", 
                            size = 40, 
                            thin_provisioned = true, 
                            index = 2,
                            }],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    },
    "vault05" = {
        hostname        = "vault05",
        datacenter      = "home",
        datastore       = "vsanDatastore",
        cluster         = "lab",
        network         = "10.0.10.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.10.55",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.10.1",
        os_disk_size    = 40,
        additionaldisks = [{
                            label = "test1disk1", 
                            size = 40, 
                            thin_provisioned = true, 
                            index = 2,
                            }],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    }
}