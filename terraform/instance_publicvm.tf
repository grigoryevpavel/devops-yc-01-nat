#создаем публичную VM
resource "yandex_compute_instance" "publicvm" {
  name = "publicvm"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"

  resources{
    cores  = var.vms_resources.publicvm.cores
    memory = var.vms_resources.publicvm.memory 
    core_fraction = var.vms_resources.publicvm.core_fraction
  } 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = var.vms_resources.publicvm.disk.type
      size = var.vms_resources.publicvm.disk.size
    }
  }
  scheduling_policy { preemptible = true }

  network_interface { 
    subnet_id = yandex_vpc_subnet.public.id
    nat = true 
  }
  metadata = {
      user-data          = data.template_file.publicvminit.rendered  
      serial-port-enable = 1
  }
} 

#инициализация публичной ВМ
data "template_file" "publicvminit" {
 template = file("./cloud-init.yml")
 vars={
     public_key=var.public_key   
 }
}