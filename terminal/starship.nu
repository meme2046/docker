source ../global.nu

def main [] {
  print 'starship script'
}
# oh-my-posh init nu --config 'atomic'
def "main nu" [] {
  let fp = $nu.config-path
  appendline $fp 'mkdir ($nu.data-dir | path join "vendor/autoload")'
  appendline $fp 'starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")'
}

def "main pwsh" [] {
  let fp = (pwsh -c "echo $PROFILE")
  appendline $fp 'Invoke-Expression (&starship init powershell)'
}
