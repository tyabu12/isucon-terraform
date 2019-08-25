provider "google" {
  credentials = "${file("./isucon7-qualifier.json")}"
  project     = "isucon7-qualifier-1ur"
  region      = "asia-northeast1"
}