#создаем публичную VM
resource "yandex_compute_instance" "privatevm" {
  name = "privatevm"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  
  resources{
    cores  = var.vms_resources.privatevm.cores
    memory = var.vms_resources.privatevm.memory 
    core_fraction = var.vms_resources.privatevm.core_fraction
  } 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = var.vms_resources.privatevm.disk.type
      size = var.vms_resources.privatevm.disk.size
    }
  }
  scheduling_policy { preemptible = true }

  network_interface { 
    subnet_id = yandex_vpc_subnet.private.id
    nat = false   
    
    security_group_ids = [
        yandex_vpc_security_group.sg-internet.id,  # Разрешаем весь исходящий трафик в интернет
        yandex_vpc_security_group.sg-private.id # Разрешаем все соединения с NAT и внутри приватной подсети.
      ]
  }
  metadata = {
      user-data          = data.template_file.privatevminit.rendered  
      serial-port-enable = 1
  }
} 

data template_file "privatevminit"{
  template = file("./cloud-init.yml")
  vars = {
    public_key = var.public_key   
  }
}