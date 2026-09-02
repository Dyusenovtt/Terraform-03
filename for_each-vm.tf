
variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 2
      ram         = 4
      disk_volume = 20
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 15
    }
  ]
}

locals {
  vm_map = {
    for vm in var.each_vm : vm.vm_name => vm
  }
}

resource "yandex_compute_instance" "database" {
  for_each = local.vm_map
  name     = each.value.vm_name
  zone     = var.default_zone
  platform_id = var.vm_common.platform_id

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  scheduling_policy {
    preemptible = var.vm_common.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_common.image_id
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "${var.vm_common.ssh_user}:${local.ssh_public_key}"
  }
}
