def main [] {
  print 'ffmpeg script'
}

def "main to-ogg" [
  dir_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1754集完"
  cover_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1754集完/cover720.jpg"
  album: string = "大奉打更人"
  artist: string = "喜马拉雅"
  --parse-episode
  --force
] {
  let ext = "mp3,m4a"
  let out_ext = "ogg"
  let files = glob $"($dir_path)/**/*.{($ext)}" | skip 95
  let total = $files | length
  mut count = 0
  mut title = ""

  if $total == 0 {
    print $"✗ 未找到任何 ($ext) 文件"
    return
  }

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')
    let source_dirname = $dir_path | path basename
    # let out_file_path = $source_file_path | str replace $source_dirname $"ogg/($source_dirname)" | path basename --replace ($in | $"($in | split column '.' | first | get column0).ogg")
    mut out_file_path = ($source_file_path | str replace $source_dirname $"ogg/($source_dirname)" | str replace -r $"\(.+\).\(('mp3,m4a' | str replace ',' '|')\)" $'$1.($out_ext)')
    if ($parse_episode) {
      let info = main parse-episode $out_file_path
      $title = $info.title
      $out_file_path = $out_file_path | path basename --replace $"($info.episode).($out_ext)" | str replace --all '\' '/'
    }

    if (($out_file_path | path exists) and not $force) {
      print $"(ansi r)⚠️ ($count)/($total)(ansi rst) (ansi bu)($out_file_path)(ansi rst) (ansi r)已存在, 跳过转换(ansi rst)"
      continue
    }

    let out_dir = $out_file_path | path dirname
    mkdir $out_dir

    (
      ^ffmpeg -y # 覆盖
      -hide_banner # 隐藏版权信息
      -loglevel error # 只显示错误信息
      -i $source_file_path # 音频路径
      # -i $cover_path # 封面路径 🏷️ogg
      # -map 0:a # 音频流映射 🏷️ogg
      # -map 1:v -disposition:v attached_pic # 指定视频编码器为 MJPEG 🏷️ogg
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
      $out_file_path
    )

    print $'(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst) > (ansi bu)($out_file_path)(ansi rst)'
  }
}

# 使用tageditor-cli设置封面
def "main te-cover" [
  dir_path: string = "d:/AudioBooks/ogg/大奉打更人_头陀渊_1754集完"
  cover_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1754集完/cover720.jpg"
] {

  if not ($cover_path | path exists) {
    print $"✗ 封面文件不存在: ($cover_path)"
    return
  }

  let ext = "ogg"
  let files = glob $"($dir_path)/**/*.{($ext)}"
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
}

def "main te-info" [
  dir_path: string = "d:/AudioBooks/ogg/大奉打更人_头陀渊_1754集完"
  --base
  --info
] {
  let ext = "ogg"
  let files = glob $"($dir_path)/**/*.{($ext)}" | take 1
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
  dir_path: string = "d:/AudioBooks/大奉打更人_头陀渊_1754集完"
] {
  let ext = "mp3,m4a"
  let files = glob $"($dir_path)/**/*.{($ext)}" | take 10
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print "✗ 未找到任何 mp3/m4a 文件"
    return
  }

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')
    let info = main parse-episode $file

    print $"(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst)\n($info | to json)"
  }
}
