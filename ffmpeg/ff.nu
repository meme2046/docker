def main [] {
  print 'ffmpeg script'
}

def "main to-opus" [
  dir_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1750集完"
  cover_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1750集完/cover720.jpg"
  artist: string = "喜马拉雅"
  --threads: int = 16
  --skip: int = 0
  --take: int = 10000
  --parse-episode
  --force
] {
  let album = $dir_path | path basename | split words | first

  let source_exts = ["mp3" "m4a"]
  let source_exts_comma = $source_exts | str join ","
  let out_ext = "opus"

  let files = glob $"($dir_path)/**/*.{($source_exts_comma)}" | skip $skip | take $take
  let total = $files | length

  if $total == 0 {
    print $"✗ 未找到任何 ($source_exts_comma) 文件"
    return
  }

  print $"✓ 共读取 ($total) 个待转换文件，并发线程：($threads)，强制覆盖：($force)"

  $files | enumerate | par-each --threads $threads --keep-order {|entry|
    let file_idx = $entry.index + 1
    let source_file = ($entry.item | str replace --all '\' '/')
    let source_dirname = $dir_path | path basename

    # 生成输出路径（逻辑和原代码完全一致）
    let p = $source_file | str replace $source_dirname $"($out_ext)/($source_dirname)" | path parse
    mut out_file = ($p.parent | path join $"($p.stem).($out_ext)") | str replace --all '\' '/'

    # 解析集数,title（如果开启）
    let title = if $parse_episode {
      let ep_info = main parse-episode $out_file
      $out_file = $out_file | path basename --replace $"($ep_info.episode).($out_ext)" | str replace --all '\' '/'
      $ep_info.title
    } else { "" }

    # 跳过已存在文件
    if (($out_file | path exists) and not $force) {
      return {
        idx: $file_idx
        status: "skip"
        msg: $"⚠️ (ansi bu)($out_file)(ansi rst) (ansi r)已存在, 跳过转换(ansi rst)"
      }
    }

    let out_dir = $out_file | path dirname
    mkdir $out_dir

    # 执行ffmpeg
    let ffmpeg_ret = (
      ^ffmpeg -y # 覆盖
      -hide_banner # 隐藏版权信息
      -loglevel error # 只显示错误信息
      -i $source_file # 音频路径
      # -i $cover_path # 封面路径 🏷️
      # -map 0:a # 音频流映射 🏷️
      # -map 1:v -disposition:v attached_pic # 指定视频编码器为 MJPEG 🏷️
      -c:a libopus # 编码器: libopus
      -ac 1 # 单声道（人声不需要立体声）
      -b:a 28k # 目标码率 28kbps
      -vbr on # 启用可变比特率
      -compression_level 10 # 压缩级别(0-10，越高压缩越好但速度慢)
      -application voip # 优化语音编码(voip:纯人声,audio:音乐播放,lowdelay:低延迟)
      -map_metadata -1 # 全局元数据清空
      -map_metadata:s:a -1 # 音频流内部标签清空
      -metadata album=($album)
      -metadata artist=($artist)
      -metadata title=($title)
      $out_file
    ) | complete

    if $ffmpeg_ret.exit_code == 0 {
      return {
        idx: $file_idx
        status: "ok"
        msg: $"✓ (ansi bu)($source_file)(ansi rst) > (ansi bu)($out_file)(ansi rst)"
      }
    } else {
      return {
        idx: $file_idx
        status: "fail"
        msg: $"✗ (ansi bu)($source_file)(ansi rst) (ansi r)ffmpeg异常, 退出码: $ffmpeg_ret.exit_code(ansi rst)"
      }
    }
  } | each {|res|
    if $res.status != "ok" {
      print $'➜ [($res.idx)/($total)] ($res.msg) ($res.status)'
    }
  } | ignore

  print $"✓ done"
}

# 使用tageditor-cli设置封面
def "main te-cover" [
  dir_path: string = "d:/AudioBooks/opus/大奉打更人_头陀渊_1750集完"
  cover_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1750集完/cover720.jpg"
  --skip: int = 0
  --take: int = 10000
] {

  if not ($cover_path | path exists) {
    print $"✗ 封面文件不存在: ($cover_path)"
    return
  }

  let ext = "opus"
  let files = glob $"($dir_path)/**/*.{($ext)}" | skip $skip | take $take
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print $"✗ 未找到任何 ($ext) 文件"
    return
  }

  let temp_dir = "d:/.cache/tageditor"
  mkdir $temp_dir

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')

    (
      ^tageditor-cli set
      --values $"cover=($cover_path):front-cover:3"
      -f $source_file_path
      --temp-dir $temp_dir
      --quiet
    )

    print $'(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst)'
  }

  rm --force $"($temp_dir)/**/*"
}

def "main te-info" [
  dir_path: string = "d:/AudioBooks/opus/大奉打更人_头陀渊_1750集完"
  --skip: int = 0
  --take: int = 3
  --base
  --info
] {
  let ext = "opus"
  let files = glob $"($dir_path)/**/*.{($ext)}" | skip $skip | take $take
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print $"✗ 未找到任何 ($ext) 文件"
    return
  }

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')

    print $'(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst)'

    if $base {
      (
        ^tageditor-cli get title artist album cover -f $source_file_path
      )
    }
    if $info {
      (
        ^tageditor-cli info --verbose
        -f $source_file_path
      )
    }

    if not $base and not $info {
      (
        ^tageditor-cli get title artist album cover -f $source_file_path
      )

      (
        ^tageditor-cli info --verbose
        -f $source_file_path
      )
    }
  }
}
# 解析文件名中的集数和标题, 匹配"第"(x)集, 中的(x)为集数, 接下来为标题字段, 必须符合这个这个规则才能解析成功
def "main parse-episode" [
  file_path: string
] {

  let name = $file_path | path basename | split words

  mut episode = ($name | first 2 | last | str replace -r '.*第(\d+).*' '$1')
  if ($episode =~ '^\d+$') {
    $episode = $episode | fill --alignment right --character '0' --width 4
  }
  let title = ($name | first 3 | last)

  return {episode: $episode title: $title}
}

def "main test-episode" [
  dir_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1750集完"
  --skip: int = 0
  --take: int = 5
] {
  let ext = "mp3,m4a"
  let files = glob $"($dir_path)/**/*.{($ext)}" | skip $skip | take $take
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print $"✗ 未找到任何 ($ext) 文件"
    return
  }

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')
    let info = main parse-episode $file

    print $"(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst)\n($info | to json)"
  }
}
