def "main github" [] {
}
# windows定时任务: 1.本地稳定ip地址同步到redis, 2.gate和bitget交易记录同步到redis,  3.data项目自动同步到github仓库
def main [dir: string = "d:/github/meme2046/data"] {
  util ipv6
  gate
  bitget sync
  cd $dir
  print $"🗂️ Project dir:(pwd)"
  git pull
  git add .
  # 检查是否有需要提交的更改
  # let status_output = (git status --porcelain | str trim)
  # if ($status_output | is-empty) {
  #     echo "没有新的更改需要推送"
  # }
  let commit_result = do { git commit -m "auto-sync" } | complete
  print $commit_result
  git push
  # if $commit_result.exit_code == 0 {
  #     git push
  # } else {
  #     git push
  #     print $commit_result.stdout
  # }
}
