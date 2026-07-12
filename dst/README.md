# dst.nu 脚本说明

1. `nu dst.nu server_file`  
   这是饥荒专服搭建的配置文件, 输入`cluster`目录就可以复制好所有必要的配置文件

2. `nu dst.nu convertup`  
   这是`modoverrides.lua`配置, 运行会更新文件里的版本信息, 输入`cluster`目录, 会将mod配置输出到`master`和`caves`目录

3. `nu dst.nu modsetup`  
   配置自动更新模组文件, 不同路径需要到脚本里修改`-o path`
