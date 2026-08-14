# e.g. S01E03.mp4
const TV_REGEX = '.*?([Ss]\d{1,2})(?:[第EePpXx\.\-\_\( ]{1,2}|^)(\d{1,4})(?!\d).*?\.(mp4|mkv)'
const AUDIOBOOK_REGEX = '.*?(?:[第EePpXx\.\-\_\( ]{1,2}|^)((\d{1,4})(?!\d).*)\.(opus|m4a|mp3)'

def main [] {
  print 'regex script'
}
def "tv-regex" [] {
}

def "main test-regex" [
  pattern: string = ""
  # dir_path: string = "d:/.filezilla/动画/诡秘之主"
  # dir_path: string = 'D:\AudioBooks\凡人修仙传_光合积木'
  dir_path: string = 'd:/AudioBooks/大奉打更人_头陀渊_1750集完'
  # dir_path: string = 'D:\AudioBooks\诡秘之主_8082Audio_2059集完'
  --skip: int = 0
  --take: int = 10
] {
  let source_dir_path = ($dir_path | str replace --all '\' '/')
  let ext = "mp3,m4a,opus,mkv,mp4"
  let files = glob $"($source_dir_path)/**/*.{($ext)}" | skip $skip | take $take
  let total = $files | length
  mut count = 0

  if $total == 0 {
    print $"✗ 未找到任何 ($ext) 文件"
    return
  }

  for file in $files {
    $count = $count + 1

    let source_file_path = ($file | str replace --all '\' '/')
    let name = ($file | path basename)

    print $"(ansi m)➜ ($count)/($total)(ansi rst) (ansi bu)($source_file_path)(ansi rst)"

    if ($pattern != "") {
      print ($name | str replace --regex $pattern '${1}E${2}.${3}')
    } else if ($name | find --regex $TV_REGEX | is-not-empty) {
      print ($name | str replace -r $TV_REGEX '${1}E${2}.${3}')
    } else if ($name | find --regex $AUDIOBOOK_REGEX | is-not-empty) {
      # print ($name | str replace -r $AUDIOBOOK_REGEX 'Pt.${2}.${3}')
      # print ($name | str replace -r $AUDIOBOOK_REGEX '${1}.${3}')
      print ($name | parse --regex $AUDIOBOOK_REGEX)
    } else {
      print $"✗ 未匹配: ($name)"
    }
  }
}

def "main tv-rename" [
  pattern: string = $TV_REGEX
  dir_path: string = "d:/.filezilla/动画/诡秘之主"
  --apply # 实际执行重命名，默认只预览
] {
  let source_dir_path = ($dir_path | str replace --all '\' '/')
  let ext = "mp3,m4a,opus,mkv,mp4"
  let files = glob $"($source_dir_path)/**/*.{($ext)}"
  let total = $files | length
  mut count = 0
  mut renamed = 0

  if $total == 0 {
    print $"✗ 未找到任何 ($ext) 文件"
    return
  }

  for file in $files {
    $count = $count + 1

    let source_file_path = ($file | str replace --all '\' '/')
    let name = ($source_file_path | path basename)
    let dir = ($source_file_path | path dirname)

    let new_name = (
      if ($pattern != "") {
        $name | str replace --regex $pattern '${1}E${2}.${3}'
      } else {
        null
      }
    )

    if ($new_name | is-empty) or $new_name == $name {
      print $"(ansi dark_gray)➜ ($count)/($total) skip: ($name)(ansi rst)"
      continue
    }

    print $"(ansi m)➜ ($count)/($total)(ansi rst) ($name) (ansi green)→(ansi rst) (ansi bu)($new_name)(ansi rst)"

    if $apply {
      mv $source_file_path ($dir | path join $new_name)
      $renamed = $renamed + 1
    }
  }

  if $apply {
    print $"(ansi green)✓ 完成 ($renamed)/($total)(ansi rst)"
  } else {
    print $"(ansi yellow)预览模式，加 --apply 实际重命名(ansi rst)"
  }
}
