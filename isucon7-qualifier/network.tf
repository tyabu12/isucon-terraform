resource "google_compute_network" "default" {
  name = "isucon7-qualifier-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow-http" {
  name    = "default-allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}