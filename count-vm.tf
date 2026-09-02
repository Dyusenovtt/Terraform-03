
resource "yandex_compute_instance" "web" {
  count = var.web_config.count
  name  = "web-${count.index + 1}"
  zone  = var.default_zone
  platform_id = var.vm_common.platform_id
  allow_stopping_for_update = true

  resources {
    cores  = var.web_config.cores
    memory = var.web_config.memory
  }

  scheduling_policy {
    preemptible = var.vm_common.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_common.image_id
      size     = var.web_config.disk
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

  depends_on = [yandex_compute_instance.database]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = var.vm_common.ssh_user
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_interface[0].nat_ip_address
    }
  }
}
