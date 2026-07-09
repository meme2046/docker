# nushell格式化, topiary

配置脚本:`./tp.nu`

## 前置条件

1. 下载: https://visualstudio.microsoft.com/zh-hans/visual-cpp-build-tools/
2. 选择选项安装(核心名称) `Windows 11 SDK` 和 `MSVC C++ x64/x86 build tool`
3. 安装**tree-sitter**: `scoop install tree-sitter`
4. 安装**Tweag.Topiary**: `winget install Tweag.Topiary`

## 配置

运行脚本: `nu ./tp.nu setup`, 会配置好topiary 格式化nushell的环境, 详情查看 `./tp.nu`

## vscode自动格式化

1. 安装这个插件: `emeraldwalk.RunOnSave`
2. 在`settings.json`中添加:

```json
{
  "emeraldwalk.runonsave": {
    "commands": [
      {
        // topiary format nushell
        "match": "\\.(nu)$",
        "isAsync": true,
        "cmd": "topiary format \"${file}\""
      }
    ]
  }
}
```

## 使用

`topiary format script.nu`
