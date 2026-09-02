
resource "yandex_compute_disk" "storage_disk" {
  count = var.storage_config.disk_count
  name  = "storage-disk-${count.index + 1}"
  type  = "network-hdd"
  size  = 1
  zone  = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name = "storage"
  zone = var.default_zone
  platform_id = var.vm_common.platform_id

  resources {
    cores  = var.storage_config.cores
    memory = var.storage_config.memory
  }

  scheduling_policy {
    preemptible = var.vm_common.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_common.image_id
      size     = var.storage_config.disk
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

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk[*].id
    content {
      disk_id = secondary_disk.value
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

