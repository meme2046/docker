def main [] {
  print 'my docker cli collection'
}
# 循环demo
def "main dav" [dir_path: string = "."] {

  let apiversion = (docker version --format json | from json).Client.ApiVersion
  print $"apiversion: ($apiversion)"

  let ps_cmd = $"[Environment]::SetEnvironmentVariable\('DOCKER_API_VERSION', '($apiversion)', 'User'\)"
  print $"ps_cmd: ($ps_cmd)"
  ^pwsh -Command $ps_cmd
}
