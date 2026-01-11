def main [] {
    print 'setting script'
}
# oh-my-posh init nu --config 'atomic'
def "main nu" [] {
    let fp = $nu.config-path
    print $fp
    let new_line = [
        'mkdir ($nu.data-dir | path join "vendor/autoload")',
        'starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")'
    ]
    let config_list = open $fp | split row -r '\n'
    mut new_config_list = []
    mut matched = false
    for item in $config_list {
        if ($item | str contains 'vendor/autoload') {
            $matched = true
        }
        $new_config_list = ($new_config_list | append $item)
    }

    if $matched == false {
        $new_config_list = ($new_config_list | append $new_line)
    }

    ($new_config_list | str join "\n" | save --force $fp)
    print "starship set successfully"
}

def "main pwsh" [] {
    let fp = (pwsh -c "echo $PROFILE")
    print $fp
    let new_line = ['Invoke-Expression (&starship init powershell)']
    let config_list = open $fp | split row -r '\n'
    mut new_config_list = []
    mut matched = false
    for item in $config_list {
        if ($item | str contains 'starship init powershell') {
            $matched = true
            $new_config_list = ($new_config_list | append $new_line)
            print "matched and replaced"
        } else {
            $new_config_list = ($new_config_list | append $item)
        }
    }

    if $matched == false {
        $new_config_list = ($new_config_list | append $new_line)
    }

    ($new_config_list | str join "\n" | save --force $fp)
    print "starship set successfully"
}