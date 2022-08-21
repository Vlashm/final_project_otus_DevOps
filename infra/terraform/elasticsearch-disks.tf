
resource "yandex_compute_disk" "elastisearch_cluster_data" {
  count = "3"
  name  = "elastisearch-cluster-data-${count.index}"
  type  = "network-hdd"
  zone  = var.zone
  size  = "15"
}