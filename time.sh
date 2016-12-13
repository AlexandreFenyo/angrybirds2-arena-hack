#!/bin/zsh

while sleep 1
do
    state=$(cat /tmp/state)

    # click sur S (stopper la partie)
    if [ "$state" = S ]
    then
	#	newtime=$(( $(cat /tmp/timewarp) - 1 ))
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
	sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
    fi

    # sur P (play), on bloque le temps
    
    now=$(date +%s)
    cat /tmp/timewarp | read timewarp
    delay=$(($timewarp - $now))
    h=$(($delay/3600))
    m=$((($delay - $h*3600) / 60 ))
    s=$(($delay - $h*3600 - $m*60))
    echo $h $m $s
    
    echo $h $m $s > /var/www/localhost/htdocs/msg2.txt
    cat /tmp/timewarp >> /var/www/localhost/htdocs/msg2.txt
    echo " mitm:" >> /var/www/localhost/htdocs/msg2.txt
    cat /tmp/timewarp.value >> /var/www/localhost/htdocs/msg2.txt
done

exit 0
