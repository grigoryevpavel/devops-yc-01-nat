resource "yandex_vpc_security_group" "sg-internet" {
  description = "Разрешен весь трафик в интернет"
  name        = "sg-internet"
  network_id  = yandex_vpc_network.develop.id


  egress {
    description    = "Разрешен весь исходящий трафик в Интернет"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = [local.cidr_internet]
  }
}

resource "yandex_vpc_security_group" "sg-private" {
  description = "Группа для приватной сети"
  name        = "sg-private"
  network_id  = yandex_vpc_network.develop.id


  ingress {
    description    = "Разрешен входящий трафик из публичной сети"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = yandex_vpc_subnet.public.v4_cidr_blocks
  }

  ingress {
    description       = "Разрешает трафик внутри группы безопасности"
    protocol          = "ANY"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group" # self_security_group - предопределенная группа включающая все ip-адреса группы безопасности
  }
}

resource "yandex_vpc_security_group" "sg-public" {
  description = "Группа для публичной сети"
  name        = "sg-public"
  network_id  = yandex_vpc_network.develop.id 
  
  ingress {
    description    = "Разрешен исходящий трафик из приватной сети"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks =  [local.cidr_internet] 
  }

  ingress {
    description    = "Разрешает SSH входящий трафик"
    protocol       = "TCP"
    port        = 22
    v4_cidr_blocks = [local.cidr_internet] 
  }
  ingress {
    description    = "Разрешает любой входящий трафик внутри сети"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    predefined_target = "self_security_group" # self_security_group - предопределенная группа включающая все ip-адреса группы безопасности
  }
}