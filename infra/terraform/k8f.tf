resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name                    = "k8s-cluster"
  folder_id               = var.folder_id
  network_id              = yandex_vpc_network.network_final_project.id
  service_account_id      = var.service_account_id
  node_service_account_id = var.node_service_account_id
  release_channel         = "RAPID"


  master {
    version   = var.version_k8s
    public_ip = true

    zonal {
      zone      = var.zone
      subnet_id = yandex_vpc_subnet.subnet_final_project.id
    }
  }
}

resource "yandex_kubernetes_node_group" "k8s_groups" {

  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "k8s-groups"
  version    = var.version_k8s

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.subnet_final_project.id}"]
    }

    metadata = {
      ssh-keys = "${var.ssh_username}:${file(var.public_key_path)}"
    }

    resources {
      cores  = 4
      memory = 8
    }

    boot_disk {
      size = 64
      type = "network-ssd"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }
}

resource "null_resource" "get_k8s_context" {
  provisioner "local-exec" {
    command = <<-EOT
      yc managed-kubernetes cluster get-credentials k8s-cluster --external --force
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml
    EOT
  }
  depends_on = [yandex_kubernetes_node_group.k8s_groups]
}
