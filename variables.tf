###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_common" {
  type = object({
    platform_id   = string
    image_id      = string
    ssh_user      = string
    preemptible   = bool
  })
  default = {
    platform_id   = "standard-v2"
    image_id      = "fd827b91d99psvq5fjit"
    ssh_user      = "ubuntu"
    preemptible   = true
  }
}

variable "web_config" {
  type = object({
    cores  = number
    memory = number
    disk   = number
    count  = number
  })
  default = {
    cores  = 2
    memory = 2
    disk   = 10
    count  = 2
  }
}
  variable "storage_config" {
  type = object({
    cores  = number
    memory = number
    disk   = number
    disk_count = number
  })
  default = {
    cores  = 2
    memory = 2
    disk   = 10
    disk_count = 3
  }
}
