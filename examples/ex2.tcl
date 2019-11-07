proc loops {} {
   for {set ii 1} {$ii < 10} {incr ii} {
       set l {} 
       for {set jj 0} {$jj < $ii} {incr jj} {
           lappend l $jj
           puts $l
       }
   }
}

loops
