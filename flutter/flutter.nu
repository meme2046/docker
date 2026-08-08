def main [] {
  print 'flutter script'
}

def "main add" [] {
  # 路由导航
  flutter pub add go_router
  # 本地数据库存储
  flutter pub add hive
  flutter pub add hive_flutter
  # 音频播放
  flutter pub add just_audio
  flutter pub add audio_service
  # 文件选择
  flutter pub add file_selector
  # 权限请求
  flutter pub add permission_handler@11.4.0
  # 路径获取
  flutter pub add path_provider
  # 文本文件处理
  flutter pub add dio
  flutter pub add uuid
}

def "main rm" [pkg_name:string] {
  flutter pub remove $pkg_name
}

# dart run build_runner build


def "main reget" [] {
  flutter clean
  flutter pub get
}

def "main jbr" [] {
  # flutter doctor -v | find -r '(.*Java binary at:\s*)(.+)' | first
  flutter doctor -v | parse --regex '.*Java binary at:\s*(.+)' | first | get capture0
}

def "main jbr-env" [] {
  let jbr_path = flutter doctor -v | parse --regex '.*Java binary at:\s*(.+)' | first | get capture0 | path dirname | path dirname | str replace --all '\' '/'
  print $"JAVA_HOME:($jbr_path)"

  ^pwsh -Command $"[Environment]::SetEnvironmentVariable\("JAVA_HOME", "($jbr_path)", "User"\)"
}

def "main clean" [project_dir: string = "c:/github/memehjs/x_audiobook_player"] {
  let android_dir = $'($project_dir)/android'

  cd $android_dir

  ./gradlew.bat --stop
  ./gradlew.bat clean
  ./gradlew.bat clean assembleDebug
}


def "main opts" [project_dir: string = "c:/github/memehjs/x_audiobook_player"] {
  let android_dir = $'($project_dir)/android'

  cd $android_dir

  let jvm_opts = "--enable-native-access=ALL-UNNAMED -Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError"

  open gradlew | str replace --regex "((?:set )?DEFAULT_JVM_OPTS=)(\"{0,2})(\n|\r\n)" $'$1($jvm_opts)' | save --force gradlew
  open gradlew.bat | str replace --regex "((?:set )?DEFAULT_JVM_OPTS=)(\"{0,2})(\n|\r\n)" $'$1($jvm_opts)' | save --force ./gradlew.bat
}

def "main run" [] {
  flutter run -d 
}
def "main up" [] {
  flutter pub outdated
  flutter pub upgrade
  # 如果你确认想升级所有包到最新大版本，再执行下面这条
  # flutter pub upgrade --major-versions
  flutter pub get
}