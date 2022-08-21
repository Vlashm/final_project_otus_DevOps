provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_dns_zone" "zone" {
  name        = "app-zone"
}

resource "yandex_dns_recordset" "app_records" {
  zone_id = data.yandex_dns_zone.zone.id

  for_each = toset(var.app_records_name)
  name    = "${each.key}.${var.app_zone}"
  type    = "A"
  ttl     = 200
  data    = ["${var.loadbalancer_external_ip}"]
}
