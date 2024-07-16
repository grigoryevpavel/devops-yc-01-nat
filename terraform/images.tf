 #образе ОС ubuntu
data "yandex_compute_image" "ubuntu" {
  family = local.ubuntu_image_family 
}

 #образе ОС nat
data "yandex_compute_image" "nat" {
  image_id = local.nat_instance_image_id
}


