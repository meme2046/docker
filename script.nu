def main [] {
    print 'my docker cli collection'
}
# 循环demo
def "main list" [dir_path:string = "."] {
    for d in (ls $dir_path | where type == dir) {
        print $d.name
    }
    print "----------------------------------------"
    ls $dir_path | where type == dir | each {print $in.name} | ignore
    print "----------------------------------------"
    echo hello | print $"($in) world!"
    print "----------------------------------------"
    ls $dir_path | where type == dir | each {echo $in.name}
    
}

def "main ts2date" [ts: string] {
    $ts | str substring 0..9 | into datetime -f "%s" | date to-timezone local | format date "%Y-%m-%d %H:%M:%S"
}