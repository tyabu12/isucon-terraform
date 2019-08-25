variable "gce_ssh_user" {
  default = "isucon-admin"
}

variable "gce_ssh_keys_file" {
  default = "~/.ssh/google_compute_engine.pub"
}

variable webapp_count {
    default = 3
}
