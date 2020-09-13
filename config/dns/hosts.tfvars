hostname = {
    "dns01" = {
        hostname        = "dns01",
        datacenter      = "home",
        datastore       = "data",
        cluster         = "lab",
        network         = "10.0.0.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.0.2",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.0.1",
        os_disk_size    = 40,
        additionaldisks = [],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    },
    "dns02" = {
        hostname        = "dns02",
        datacenter      = "home",
        datastore       = "data",
        cluster         = "lab",
        network         = "10.0.10.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.10.2",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.10.1",
        os_disk_size    = 40,
        additionaldisks = [],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    },
    "dns03" = {
        hostname        = "dns03",
        datacenter      = "home",
        datastore       = "data",
        cluster         = "lab",
        network         = "10.0.20.0/24"
        template        = "ubuntu_20",
        domain          = "lab.bertahome",
        ipv4_address    = "10.0.20.2",
        ipv4_netmask    = 24,
        ipv4_gateway    = "10.0.20.1",
        os_disk_size    = 40,
        additionaldisks = [],
        cpu             = 2,
        ram             = 4096,
        tags            = []
    }
}
