#!/bin/zsh

timewarp=$(cat /tmp/timewarp)

if [ "$PATH_INFO" = "/A" ]
then
    echo Content-type: text/html
    echo
    echo OK - $timewarp
    echo '<a href="http://hack.com/cgi-bin/index.cgi">time warp</a>'
    exit 0
fi

echo Content-type: text/html
echo Location: http://hack.com/cgi-bin/index.cgi/A
echo
echo -n $((timewarp+1)) > /tmp/timewarp
sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
exit 0
