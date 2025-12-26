def main [] {
    print 'setting script'
}

def "main nu" [--theme = "atomic"] {
    let fp = $nu.config-path
    print $fp
    let new_line = $"oh-my-posh init nu --config '($theme)'"
    let config_list = open $fp | split row -r '\n'
    mut new_config_list = []
    mut matched = false
    for item in $config_list {
        if ($item | str contains 'oh-my-posh init') {
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
    print $"oh-my-posh theme: [($theme)] set successfully"
}

def "main pwsh" [--theme = "atomic"] {
    let fp = (pwsh -c "echo $PROFILE")
    print $fp
    let new_line = $"oh-my-posh init pwsh --config '($theme)' | Invoke-Expression"
    let config_list = open $fp | split row -r '\n'
    mut new_config_list = []
    mut matched = false
    for item in $config_list {
        if ($item | str contains 'oh-my-posh init') {
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
    print $"oh-my-posh theme: [($theme)] set successfully"
}