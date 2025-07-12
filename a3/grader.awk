#!/usr/bin/awk -f
# Calculate average from total and count
function average(total, count) {
    return total / count
}

#Gives the proper heading
BEGIN {
    FS = ","
    print "Student Results"
    print "==============="
}

NR == 1 {
    subjectCount = NF - 2
    next
}

{
    student = $2
    sum = 0
    #Main logic for how to figure out statistics of the student
    for (i = 3; i <= NF; i++) sum += $i

    totalScore[student] = sum
    avg = average(sum, subjectCount)
    #Logic for the pass and fail
    if (avg  >= 70)
        status = "Pass"
    else
        status = "Fail"

    if(NR == 2) {
	highest = sum
	lowest = sum
    } 
    #Logic for replacing the score to print out in the future
    else {
        if (sum > highest) {
            highest = sum
            topStudent = student
        }
    
        if (sum < lowest) {
            lowest = sum
            bottomStudent = student
        }
    }
     #Formatting the output
     print "Name: " $2
     print "  Total: " sum
     print "  Average: " avg
     print "  Status: " status
     print ""
}
END {
    #Lastly, if there are multiple students scoring low or high this will help find it and print it
    print "Students who scored highest"	
    print "---------------------------"	
    for(i in totalScore){
       if(totalScore[i] == highest)     	     
           print "Name: " i  " with score " highest
    }
    print "\nStudents who scored lowest"
    print "---------------------------"
    for(i in totalScore){
       if(totalScore[i] == lowest)
           print "Name: " i " with score " lowest
    }
}
