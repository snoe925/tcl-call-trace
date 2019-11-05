proc say_hi {} {
  set fh [open "/dev/tty" w]
  puts $fh hi
}

set tcl_traceExec 3

say_hi
