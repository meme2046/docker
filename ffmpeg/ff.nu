def main [] {
  print 'ffmpeg script'
}

def "main to-opus" [
  dp: string = "d:/天翼PC备份/AudioBooks/诡秘之主_8082Audio_2059集完"
  album: string = "诡秘之主"
  artist: string = "喜马拉雅"
  --force
] {

  let files = glob $"($dp)/**/*.{mp3,m4a}" | take 3
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
      -c:a libopus # 使用 Opus 编码器
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

    # (
    #   ^ffmpeg -y
    #   -hide_banner
    #   -loglevel error
    #   -i $source_file_path
    #   -ac 1
    #   -f wav - | ^opusenc
    #   --bitrate 28
    #   --vbr
    #   --speech
    #   --comp 10
    #   --downmix-mono
    #   --picture $cover_path
    #   --title ""
    #   --artist $artist
    #   --album $album
    #   -
    #   $out_file_path
    # )

    # (
    #   ^opusenc
    #   --bitrate 28
    #   --vbr
    #   --speech
    #   --comp 10
    #   --downmix-mono
    #   --picture $cover_path
    #   --title ""
    #   --artist $artist
    #   --album $album
    #   $source_file_path
    #   $out_file_path
    # )

    print $'(ansi r)➜ ($count)/($total)(ansi rst) (ansi bu)($file)(ansi rst) to (ansi bu)($out_file_path)(ansi rst)'
  }
}

# 添加封面
def "main cover" [
  dp: string = "d:/天翼PC备份/AudioBooks/opus/诡秘之主_8082Audio_2059集完"
  cover_path: string = "d:/天翼PC备份/AudioBooks/opus/诡秘之主_8082Audio_2059集完/cover.jpg"
] {

  if not ($cover_path | path exists) {
    print $"✗ 封面文件不存在: ($cover_path)"
    return
  }

  let files = glob $"($dp)/**/*.{opus}"
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print "✗ 未找到任何 mp3/m4a 文件"
    return
  }

  for file in $files {
    $count = $count + 1
    let source_file_path = ($file | str replace --all '\' '/')

    (
      ^tageditor-cli set
      --values $"cover=($cover_path):front-cover"
      -f $source_file_path
      --quiet
    )

    print $'(ansi r)➜ ($count)/($total)(ansi rst) (ansi bu)($file)(ansi rst)'
  }
}
