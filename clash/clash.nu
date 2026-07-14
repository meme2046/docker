const CLASH_PARTY_URL = "https://raw.githubusercontent.com/IvanSolis1989/Smart-Config-Kit/main/Clash%20Party/ClashParty(mihomo).js";
const CLASH_PARTY_SMART_URL = "https://raw.githubusercontent.com/IvanSolis1989/Smart-Config-Kit/main/Clash%20Party/ClashParty(mihomo-smart).js";
const FI_CLASH_URL = "https://raw.githubusercontent.com/IvanSolis1989/Smart-Config-Kit/main/FlClash/FlClash(mihomo).js";

def main [] {
  print 'clash script'
}

# 获取ClashParty(mihomo).js脚本, 添加自定义配置, 并输出_update文件
def "main config" [
  --type: string # 配置类型: clash-party, clash-party-smart, flclash
] {
  # 设置默认类型
  let config_type = if $type == null { "clash-party" } else { $type };

  # 根据类型选择目标 URL
  mut target_url = $CLASH_PARTY_SMART_URL;
  mut output_suffix = "";

  match $config_type {
    "clash-party" => {
      $target_url = $CLASH_PARTY_URL;
      $output_suffix = "";
    }
    "clash-party-smart" => {
      $target_url = $CLASH_PARTY_SMART_URL;
      $output_suffix = "-smart";
    }
    "flclash" => {
      $target_url = $FI_CLASH_URL;
      $output_suffix = "-flclash";
    }
    _ => {
      print ($"✗ Unknown type: ($config_type). Available types: clash-party, clash-party-smart, flclash")
      return
    }
  }

  let url_data = $target_url | url parse

  let basename = $"($url_data.path | path basename)";

  let download_path = $"./($basename)";

  print ($"Downloading from: ($target_url)")
  print ($"Downloading to: ($download_path)")

  rm -f $download_path

  http get $target_url | save --force $download_path
  if ($download_path | path exists) {
    print ($"✓ Successfully downloaded to: ($download_path)")
  } else {
    print "✗ Download failed!"
    return
  }

  ^me js clash $download_path ./custom.clash.config.json

  # 根据类型选择输出文件
  if $config_type == "clash-party-smart" {
    cp --force --verbose "ClashParty(mihomo-smart)_update.js" $"d:/github/meme2046/data/clash/($basename)"
  } else if $config_type == "flclash" {
    cp --force --verbose "FlClash(mihomo)_update.js" $"d:/github/meme2046/data/clash/($basename)"
  } else {
    cp --force --verbose "ClashParty(mihomo)_update.js" $"d:/github/meme2046/data/clash/($basename)"
  }
}
