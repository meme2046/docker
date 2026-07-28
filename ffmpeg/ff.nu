def main [] {
  print 'ffmpeg script'
}

def "main to-opus" [
  dp: string = "d:/天翼PC备份/AudioBooks/诡秘之主_8082Audio_2059集完"
  cover_path: string = "d:/天翼PC备份/AudioBooks/opus/诡秘之主_8082Audio_2059集完/cover720.jpg"
  album: string = "诡秘之主"
  artist: string = "喜马拉雅"
  --force
] {

  let files = glob $"($dp)/**/*.{mp3,m4a}" | skip 2068 | take 1000
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print "✗ 未找到任何 mp3/m4a 文件"
    return
  }

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')
    let source_dirname = $dp | path basename
    let out_file_path = $source_file_path | str replace $source_dirname $"opus/($source_dirname)" | path basename --replace ($in | $"($in | split column '.' | first | get column0).opus")

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
      -metadata title=
      $out_file_path
    )

    print $'(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst) > (ansi bu)($out_file_path)(ansi rst)'
  }
}

# 使用tageditor-cli设置封面
def "main te-cover" [
  dp: string = "d:/天翼PC备份/AudioBooks/opus/诡秘之主_8082Audio_2059集完"
  cover_path: string = "d:/天翼PC备份/AudioBooks/opus/诡秘之主_8082Audio_2059集完/cover720.jpg"
] {

  if not ($cover_path | path exists) {
    print $"✗ 封面文件不存在: ($cover_path)"
    return
  }

  let files = glob $"($dp)/**/*.{opus}" | skip 0 | take 2
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print "✗ 未找到任何 opus 文件"
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
  dp: string = "d:/天翼PC备份/AudioBooks/opus/诡秘之主_8082Audio_2059集完"
] {
  let files = glob $"($dp)/**/*.{opus}" | skip 0 | take 2
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print "✗ 未找到任何 opus 文件"
    return
  }

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')

    print $'(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst)'

    (
      ^tageditor-cli info --verbose
      -f $source_file_path
    )

    (
      ^tageditor-cli get title artist album cover -f $source_file_path
    )
  }
}
