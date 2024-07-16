locals {
  nat_instance_image_id  = "fd80mrhj8fl2oe87o4e1" # Образ для nat инстанса. Можно использовать также образ fd82fnsvr0bgt1fid7cl Подробнее https://cloud.yandex.ru/marketplace/products/yc/nat-instance-ubuntu-18-04-lts for details.
  ubuntu_image_family    = "ubuntu-2204-lts"
  cidr_internet          = "0.0.0.0/0"            # Все IP-адреса.
}