terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
local = {
   source = "hashicorp/local"
   version = "~>2.0"
    }
  }
  required_version = "~>1.12.0"
}

provider "yandex" {
  service_account_key_file     = "key.json"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}
