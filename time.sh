#!/bin/zsh

DOCKER=true

while sleep .3
do
    cat /tmp/state | read state

    # user wants to stop time
    if [ "$state" = S ]
    then
        cat /tmp/timewarp | read newtime
	date +%s | read now
	if [ $newtime -le $now ]
	then
	    newtime=$now
	fi
	echo -n $newtime > /tmp/timewarp
    fi
    
    # user wants to debug time warp
    debug=false
    if [ "$state" = D ]
    then
	debug=true
	state=T
    fi
    # user wants to make the time warp
    if [ "$state" = T ]
    then
	if [ $debug = true ]
	then
	    echo -n $(( $(cat /tmp/timewarp) + 15 )) > /tmp/timewarp
	else
	    echo -n $(( $(cat /tmp/timewarp) + 3600 )) > /tmp/timewarp
	fi
	echo -n P > /tmp/state
	cat /tmp/timewarp > /tmp/timewarp.value

	if [ $DOCKER = true ]
	then
	    sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
	else
	    sh -c "sleep .5; pkill mitmproxy" > /dev/null 2>&1 &
	fi
    fi

    date +%s | read now
    cat /tmp/timewarp | read timewarp
    delay=$(( $timewarp - $now ))
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
	echo "You can now play in the Arena, the time control is activated<br/>" > /var/www/localhost/htdocs/msg.txt
	echo "The time is currently suspended: click on Time Warp to fast forward and get a free ticket now!<br/>" >> /var/www/localhost/htdocs/msg.txt

	if [ $delay -lt 0 ]
	then
	    echo "you are <b>-$h:$m:$s</b> in the <b>Past</b>" >> /var/www/localhost/htdocs/msg.txt
	else
	    echo "you are <b>+$h:$m:$s</b> in the <b>Future</b>" >> /var/www/localhost/htdocs/msg.txt
	fi
    fi

    if [ "$state" = S ]
    then
	echo "The time control is not activated: you can now exit the Arena<br/>" > /var/www/localhost/htdocs/msg.txt
	echo "If you click on Play and enter the Arena, you will be <b>$h:$m:$s</b> in the future,<br/>then click on Time Warp to get a free ticket!" >> /var/www/localhost/htdocs/msg.txt
    fi
done

exit 1
