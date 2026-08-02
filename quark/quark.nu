def main [] {
  print 'quark script'
}

def "main compose" [
] {
  let fp = $"($env.PROJECT_DOCKER_DIR)/quark/compose.yaml"
  docker compose -p quark -f $fp up -d
}

# quark签到
def "main ck" [--download] {

  let local_tmp = $"($env.PROJECT_DOCKER_DIR)/quark/ck_tmp"
  let remote_ck = "https://raw.githubusercontent.com/BNDou/Auto_Check_In/main/checkIn_Quark.py"
  let remote_notify = "https://raw.githubusercontent.com/BNDou/Auto_Check_In/main/utils/notify.py"

  let local_ck = $"($local_tmp)/($remote_ck | path basename)"
  let local_notify = $"($local_tmp)/utils/($remote_notify | path basename)"

  if ($download or not ($local_ck | path exists) or not ($local_notify | path exists)) {
    mkdir ($local_ck | path dirname)
    mkdir ($local_notify | path dirname)

    print ($"(ansi bu)($remote_ck)(ansi rst) > (ansi bu)($local_ck)(ansi rst)")
    print ($"(ansi bu)($remote_notify)(ansi rst) > (ansi bu)($local_notify)(ansi rst)")

    http get $remote_ck | save --force $local_ck
    http get $remote_notify | save --force $local_notify
  }

  # 需设置环境变量:COOKIE_QUARK, DD_BOT_TOKEN, DD_BOT_SECRET
  uv run --with requests $local_ck
}
