# windows路由相关命令
const HOST_IP = "192.168.123.7"

def main [] {
  route print | find "192.168.123"
}

def "main run" [] {
  gost -C ./config.yaml
}


# 添加静态永久路由 公网ip -> HOST_IP
def "main add" [ip: string] {
  route add $ip mask 255.255.255.255 192.168.123.1 -p;
  route print | findstr $ip
}

def "main del" [ip: string] {
  route delete $ip
}