# Создаем таблицу маршрутизации
resource "yandex_vpc_route_table" "route-table-nat" {
  name       = "route-table-nat"
  network_id = yandex_vpc_network.develop.id
  
  depends_on = [
    yandex_compute_instance.nat
  ]

  static_route {
    destination_prefix = local.cidr_internet
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  } 
}


#создаем nat инстанс
resource "yandex_compute_instance" "nat" {
  name = "nat"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  
  resources{
    cores  = var.vms_resources.nat.cores
    memory = var.vms_resources.nat.memory 
    core_fraction = var.vms_resources.nat.core_fraction
  } 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat.image_id
      type = var.vms_resources.nat.disk.type
      size = var.vms_resources.nat.disk.size
    }
  }
  scheduling_policy { preemptible = true }

  network_interface { 
    subnet_id = yandex_vpc_subnet.public.id
    nat = true
    ip_address = "192.168.10.254"

    security_group_ids = [
      yandex_vpc_security_group.sg-internet.id,    # Разрешаем весь исходящий трафик в Интернет.
      yandex_vpc_security_group.sg-public.id # Разрешаем все соединения с публичной подсетью.
    ]
  }
  metadata = {
      user-data          = data.template_file.natvminit.rendered  
      serial-port-enable = 1
  }
} 

#инициализация nat ВМ
data "template_file" "natvminit" {
 template = file("./cloud-init.yml")
 vars={
     public_key=var.public_key
 }
}
