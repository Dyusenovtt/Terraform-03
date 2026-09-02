
locals {

  all_vms = merge(

    { for idx, vm in yandex_compute_instance.web : 
      "web-${idx + 1}" => {
        hostname = vm.name
        fqdn     = vm.fqdn
        ip       = vm.network_interface[0].nat_ip_address
        group    = "webservers"
      }
    },

    { for name, vm in yandex_compute_instance.database : 
      name => {
        hostname = vm.name
        fqdn     = vm.fqdn
        ip       = vm.network_interface[0].nat_ip_address
        group    = "databases"
      }
    },

    {
      "storage" = {
        hostname = yandex_compute_instance.storage.name
        fqdn     = yandex_compute_instance.storage.fqdn
        ip       = yandex_compute_instance.storage.network_interface[0].nat_ip_address
        group    = "storage"
      }
    }
  )
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    vms = local.all_vms
  })
  filename = "${path.module}/inventory.ini"
}
