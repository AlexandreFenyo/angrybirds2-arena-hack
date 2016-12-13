#!/bin/zsh

DOCKER=false

while sleep .3
do
    cat /tmp/state | read state

    # S=stop
    if [ "$state" = S ]
    then
        newtime=$(( $(cat /tmp/timewarp) ))
	now=$(date +%s)
	if [ $newtime -le $now ]
	then
	    newtime=$now
	fi
	echo -n $newtime > /tmp/timewarp

	#	date +%s | read X
#	echo -n $X > /tmp/timewarp.value
#	sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
    fi

    
    # click sur time warp
    if [ "$state" = T ]
    then
	#	echo -n $(( $(cat /tmp/timewarp) + 3600 )) > /tmp/timewarp
	echo -n $(( $(cat /tmp/timewarp) + 15 )) > /tmp/timewarp
	echo -n P > /tmp/state
	cat /tmp/timewarp > /tmp/timewarp.value
	# a remettre avec docker
	# sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
	sh -c "sleep .5; pkill mitmproxy" > /dev/null 2>&1 &
    fi

    # sur P (play), on bloque le temps
    
    now=$(date +%s)
    cat /tmp/timewarp | read timewarp
    delay=$(($timewarp - $now))
    if [ $delay -ge 0 ]
    then
	abs=$delay
    else
	abs=$(( -delay ))
    fi
    printf "%02d" $(($abs/3600)) | read h
    printf "%02d" $((($abs - $h*3600) / 60 )) | read m
    printf "%02d" $(($abs - $h*3600 - $m*60)) | read s

    if [ "$state" = T ]
    then
	echo "please wait" > /var/www/localhost/htdocs/msg.txt
    fi

    if [ "$state" = P ]
    then
	echo "You can play in the Arena<br/>" > /var/www/localhost/htdocs/msg.txt
	echo "The time is currently stopped<br/>Click timewarp to fastforward and do not wait until next free ticket!" >> /var/www/localhost/htdocs/msg.txt

	if [ $delay -lt 0 ]
	then
	    echo "you are now -$h:$m:$s in the Past" >> /var/www/localhost/htdocs/msg.txt
	else
	    echo "you are now +$h:$m:$s in the Future" >> /var/www/localhost/htdocs/msg.txt
	fi

    fi

    if [ "$state" = S ]
    then
	echo "You can exit the Arena<br/>" > /var/www/localhost/htdocs/msg.txt
	echo "The real time is set<br/>" >> /var/www/localhost/htdocs/msg.txt
	echo "if your click start and enter the Arena, you will be $h:$m:$s in the Future" >> /var/www/localhost/htdocs/msg.txt

    fi
   
#    echo $h $m $s '<br>' > /var/www/localhost/htdocs/msg.txt
#    echo " tw:" >> /var/www/localhost/htdocs/msg.txt
#    cat /tmp/timewarp >> /var/www/localhost/htdocs/msg.txt
#    echo " mitm:" >> /var/www/localhost/htdocs/msg.txt
#    cat /tmp/timewarp.value >> /var/www/localhost/htdocs/msg.txt
#    echo '<br>' >> /var/www/localhost/htdocs/msg.txt

    echo
    echo
    echo $h $m $s '<br>'
    echo " tw:"
    cat /tmp/timewarp
    echo -n " mitm:"
    cat /tmp/timewarp.value


done

exit 0
