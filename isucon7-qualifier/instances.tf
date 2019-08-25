resource "google_compute_address" "webapp" {
  count = "${var.webapp_count}"
  name  = "isucon7-webapp-${format("%d", count.index + 1)}"
}

resource "google_compute_instance" "webapp" {
  count        = "${var.webapp_count}"
  name         = "isucon7-webapp-${format("%d", count.index + 1)}"
  machine_type = "g1-small"
  zone         = "asia-northeast1-b"
  description  = "isucon7 webapp"
  tags         = ["http-server", "webapp", "${format("webapp-%d", count.index + 1)}"]

  boot_disk {
    // インスタンス削除時にディスクも削除するか
    # auto_delete = true

    initialize_params {
      image = "isucon7-qualifier-webapp"
      // ディスクの種類 標準:"pd-standard", SSD:"pd-ssd"
      type = "pd-ssd"
      // ディスクサイズ(GB)
      size = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_network.default.gateway_ipv4}"
      // 未指定の場合はエフェメラルIP。外部IPが不要の場合は access_config 項目自体を削除
    }
  }

  metadata = {
    block-project-ssh-keys = true
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_keys_file)}"
  }
}

output "webapp-ips" {
  value = "${join(", ", google_compute_instance.webapp.*.network_interface.0.access_config.0.nat_ip)}"
}

resource "google_compute_address" "bench" {
  name  = "isucon7-bench"
}

resource "google_compute_instance" "bench" {
  name         = "isucon7-webapp-bench"
  machine_type = "g1-small"
  zone         = "asia-northeast1-b"
  description  = "isucon7 bench"
  tags         = ["http-server", "bench"]

  boot_disk {
    // インスタンス削除時にディスクも削除するか
    # auto_delete = true

    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
      // ディスクの種類 標準:"pd-standard", SSD:"pd-ssd"
      type = "pd-ssd"
      // ディスクサイズ(GB)
      size = 10
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_network.default.gateway_ipv4}"
      // 未指定の場合はエフェメラルIP。外部IPが不要の場合は access_config 項目自体を削除
    }
  }

  metadata = {
    block-project-ssh-keys = true
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_keys_file)}"
  }
}

output "bench-ip" {
  value = "${google_compute_instance.bench.network_interface.0.access_config.0.nat_ip}"
}