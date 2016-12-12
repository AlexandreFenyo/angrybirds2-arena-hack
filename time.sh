#!/bin/zsh

#echo -n $((timewarp+1)) > /tmp/timewarp
# sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &

while sleep 1
do
    state=$(cat /tmp/state)

    # click sur S (stopper la partie)
    if [ "$state" = S ]
    then
	newtime=$(( $(cat /tmp/timewarp) - 1 ))
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
	echo -n $(( $(cat /tmp/timewarp) + 3600 )) > /tmp/timewarp
	echo -n P > /tmp/state
	cat /tmp/timewarp > /tmp/timewarp.value
	sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
    fi

    # sur P (play), on bloque le temps
    
    now=$(date +%s)
    cat /tmp/timewarp.value | read timewarp
    delay=$(($timewarp - $now))
    h=$(($delay/3600))
    m=$((($delay - $h*3600) / 60 ))
    s=$(($delay - $h*3600 - $m*60))
    echo $h $m $s
    
    echo $h $m $s > /var/www/localhost/htdocs/msg.txt
    cat /tmp/timewarp >> /var/www/localhost/htdocs/msg.txt
done

exit 0
