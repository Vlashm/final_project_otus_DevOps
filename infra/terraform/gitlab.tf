resource "yandex_compute_instance" "gitlab" {
  name = "gitlab"
  zone = var.zone

  labels = {
    tags = "gitlab"
  }

  resources {
    cores  = 2
    memory = 6
  }

  boot_disk {
    initialize_params {
      size     = 50
      image_id = var.image_id_gitlab
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_final_project.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.public_key_path)}"
  }
}

resource "yandex_dns_recordset" "app_records_gitlab" {
  zone_id = yandex_dns_zone.app_zone.id

  name       = "gitlab.${var.app_zone}"
  type       = "A"
  ttl        = 200
  data       = [yandex_compute_instance.gitlab.network_interface.0.nat_ip_address]
  depends_on = [yandex_dns_zone.app_zone]
}
