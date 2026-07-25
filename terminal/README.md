# alacritty

1. 配置文件在 `./alacritty.toml`
2. 运行配置脚本即可 `nu alc.nu setup`
3. 更改 `./alacritty.toml` 后, 也需要运行 `nu alc.nu setup` 来更新配置
4. 字体配置依赖 `scoop install -g FiraCode-NF-Mono`
5. alacritty 皮肤切换, `nu alacritty.nu theme <theme_name>`, 本地没有的皮肤, 会从远程仓库下载: https://github.com/alacritty/alacritty-theme/tree/master/themes

# starship

1. 配置文件在 `./starship.toml`
2. (可选)需要配置 startship, 运行 `starship config`, 将 `./starship.toml` 复制到打开文件中即可
3. 运行 `nu starship.nu pwsh` 为 `pwsh` 添加starship配置
4. 运行 `nu starship.nu nu` 为 `nushell` 添加starship配置

# windows.terminal

1. 配置文件在 `./windows.terminal.settings.json` 复制覆盖配置即可
