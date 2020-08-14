hostname = {
    "testserver1" = {
        hostname        = "testserver1",
        datacenter      = "testdc",
        datastore       = "ds1",
        cluster         = "testcluster",
        network         = "VM Network"
        template        = "ubuntutmpl",
        domain          = "dev.bertahome",
        ipv4_address    = "192.168.255.30",
        ipv4_netmask    = 24,
        ipv4_gateway    = "192.168.255.1",
        os_disk_size    = 40,
        cpu             = 1,
        ram             = 2048,
        tags            = []
    },
    "testserver2" = {
        hostname        = "testserver2",
        datacenter      = "testdc",
        datastore       = "ds1",
        cluster         = "testcluster",
        network         = "VM Network"
        template        = "ubuntutmpl",
        domain          = "dev.bertahome",
        ipv4_address    = "192.168.255.31",
        ipv4_netmask    = 24,
        ipv4_gateway    = "192.168.255.1",
        os_disk_size    = 40,
        cpu             = 1,
        ram             = 2048,
        tags            = []
    }
}