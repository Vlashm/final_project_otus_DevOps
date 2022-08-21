provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_vpc_network" "network_final_project" {
  name = "network-final-project"
}

resource "yandex_vpc_subnet" "subnet_final_project" {
  name           = "subnet-final-project"
  v4_cidr_blocks = [var.v4_cidr]
  zone           = var.zone
  network_id     = yandex_vpc_network.network_final_project.id
}

resource "yandex_dns_zone" "app_zone" {
  name = "app-zone"

  zone   = var.app_zone
  public = true
}
