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
