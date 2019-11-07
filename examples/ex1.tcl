proc bump_up {} {
   incr ::n
}

proc bump_down {} {
   incr ::n -1
}

set ::n 0

puts [pwd]

for {set ii 0} {$ii < 100} {incr ii} {
     bump_up
     bump_down
}
