variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
  sensitive   = true
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  sensitive   = true
}

variable   "public_key"   {
  type = string 
  sensitive = true
}
  
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "имя сети"
} 


# Ресурсы всех ВМ
variable "vms_resources"{ 
  type = map
  default={
        nat={  
            cores  = 2
            memory = 1 
            core_fraction = 5
            disk = {
               type = "network-hdd"
               size = 20
            }
        } 
        publicvm={  
            cores  = 2
            memory = 1 
            core_fraction = 5
            disk = {
               type = "network-hdd"
               size = 20
            }
        } 
        privatevm={  
            cores  = 2
            memory = 1 
            core_fraction = 5
            disk = {
               type = "network-hdd"
               size = 20
            }
        } 
    }
} 