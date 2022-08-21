resource "local_file" "elasticsearch_id_file" {
  content  = <<-EOF
    elasticseach_id:
        - name: data-es-cluster-0
          value: ${yandex_compute_disk.elastisearch_cluster_data[0].id}
        - name: data-es-cluster-1
          value: ${yandex_compute_disk.elastisearch_cluster_data[1].id}    
        - name: data-es-cluster-2
          value: ${yandex_compute_disk.elastisearch_cluster_data[2].id}
    EOF
  filename = "../ansible/values/elasticsearch_id_file.yml"
}

resource "local_file" "ansible_inventory" {
  content  = <<-EOF
    [gitlab]
    gitlab-host ansible_host=${yandex_compute_instance.gitlab.network_interface.0.nat_ip_address}
    EOF
  filename = "../ansible/inventory"
}
