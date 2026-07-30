def main [] {
  print 'quark script'
}

def "main compose" [
] {
  let fp = $"($env.PROJECT_DOCKER_DIR)/quark/compose.yaml"
  docker compose -p quark -f $fp up -d
}
