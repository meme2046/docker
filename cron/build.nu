def main [] {
    print 'build script'
}

def "main jobs" [dir_path:string = "."] {
  for d in (ls $dir_path | where type == dir) {
    print $"building ($d.name)...";
    CGO_ENABLED=0 GOOS=linux ^go build -o $"/go-job-output/($d.name)" $"./($d.name)/."
  }
}