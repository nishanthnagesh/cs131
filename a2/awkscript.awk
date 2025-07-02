NR == 1{
     #initialized arrays using the header row	
     for (i = 1; i <= NF; i++) {
        feature[i] = $i
        count[i] = 0
        sum[i] = 0
	mean[i] = 0
        sumsq[i] = 0
        }
    fcount = NF
   #print NF
    next
    }

    NR == FNR {
    #first pass; collect count,sum,min,max for the numeric fields
     for (i = 1; i <= NF; i++) {
        val = $i + 0
        if ($i ~ /^-?[0-9]+(\.[0-9]+)?$/) {
            if (count[i] == 0) {
                min[i] = val
                max[i] = val
            }
            count[i]++
            sum[i] += val
            if (val < min[i]) min[i] = val
            if (val > max[i]) max[i] = val
        }
      }
    }

    NR > 1 && FNR ==1 {
     #calculating the mean for each numeric field
      for (i = 1; i <= NF; i++) {
       if(count[i] != 0)
             mean[i] = sum[i]/count[i]
      }
      next
    }

    NR != FNR {
       for (i = 1; i <= NF; i++) {
         if ($1 ~ /^-?[0-9]+(\.[0-9]+)?$/) {
             sumsq[i] += ($i - mean[i]) ^ 2
        }
      }
    }

    END {
    print "# Feature Summary for", FILENAME
    print ""
    print "## Feature Index and Names"
    for (i = 1; i <= NF; i++) {
        gsub(/"/, "", feature[i])
        print i ". " feature[i]
    }
    print ""
    print "## Statistics (Numerical Features)"
    print "| Index | Feature             |  Min  |  Max  | Mean   | StdDev |"
    print "|-------|----------------------|-------|-------|--------|--------|"
    for (i = 1; i <= fcount; i++) {
        if (count[i] == FNR - 1) {
            stdev = sqrt(sumsq[i] / count[i])
            printf "| %-5d | %-20s | %6.2f | %6.2f | %6.3f | %7.3f |\n", i, feature[i], min[i], max[i], mean[i], stdev
        }
    }
}
