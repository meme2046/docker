def main [] {
  print 'telegram script'
}
# 循环demo
def "main up" [dir_path: string = "."] {
  let ret = (
    http post --content-type multipart/form-data
    $"https://api.telegram.org/bot($env.TELE_BOT_TOKEN)/sendDocument"
    {
      chat_id: $env.TELE_ONEDAOSHARE
      document: (open -r "d:/AudioBooks/opus/诡秘之主_8082Audio_2059集完/_cover720.jpg" | into binary)
    }
  )

  print ($ret | to json)
}

# BQACAgUAAyEGAAMBDCKr3AADBGqEQjRXj1j9h_DTRwPCBSA8xaY_AAJRIAACyiQhVINnH0JgnaaOPQQ
# BQACAgUAAyEGAAMBDCKr3AADBWqEQokBhDLaAxYWenMcUBiwCUqUAAJUIAACyiQhVOJ1KRUF3-hkPQQ

def "main curlup" [dir_path: string = "."] {
  (
    curl -X POST $"https://api.telegram.org/bot($env.TELE_BOT_TOKEN)/sendDocument"
    -F $"chat_id=($env.TELE_ONEDAOSHARE)"
    -F $"document=@d:/AudioBooks/opus/诡秘之主_8082Audio_2059集完/_cover720.jpg"
  )
}

def "main getfile" [dir_path: string = "."] {
  let file_id = "BQACAgUAAyEGAAMBDCKr3AADA2qEOy1iGtaOWqmOwmtxXHdkgyAnAAI1IAACyiQhVO-Ov816mYpqPQQ"
  let ret = http $"https://api.telegram.org/bot($env.TELE_BOT_TOKEN)/getFile?file_id=($file_id)"
  let file_path = $ret.result.file_path

  http $"https://api.telegram.org/file/bot($env.TELE_BOT_TOKEN)/($file_path)" | save $"./tmp/_cover720.jpg"
}
