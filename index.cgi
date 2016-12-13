#!/bin/zsh

DOCKER=true

cat /tmp/timewarp | read timewarp

if [ "$PATH_INFO" = "" ]
then
    echo Content-type: text/html
    echo

echo '
<html>

  <head>
    <script type="text/javascript">
      var xhr = new XMLHttpRequest()
      xhr.onreadystatechange = function() {
      if (xhr.readyState == 4 && (xhr.status == 200 || xhr.status == 0))
      document.getElementById("msg").innerHTML = xhr.responseText
      }
      function loop() {
      xhr.open("GET", "/msg.txt", true)
      xhr.send(null)
      setTimeout(loop, 500)
      }
    </script>
  </head>

  <body>
    <script type="text/javascript">
      setTimeout(loop, 500)
    </script>
    <center><a href="/"><img border="0" src="/title.png"/></a><br/><font face="verdana" size="-1px">[<a href="/">home - certificate/profile</a>]</font><p/></center>
    <center><font face="verdana" id="msg">wait...</font><br/></center>
'

if [ $(cat /tmp/state) != 'S' ]
then
echo '
    <center>
    <table width="600">
    <tr><td align="left">
    <a href="http://hack.com/cgi-bin/index.cgi/S"><img src="/stop.png"/></a>
    </td><td align="right">
    <a href="http://hack.com/cgi-bin/index.cgi/T"><img src="/timewarp.png"/></a>
    </td></tr>
    </table>
    </center>
'
else
echo '
    <center>
    <a href="http://hack.com/cgi-bin/index.cgi/P"><img src="/play.png"/></a>
    </center>
'
fi

echo '
  </body>
</html>
'

exit 0
fi

if [ "$PATH_INFO" = "/P" ]
then
    echo Content-type: text/html
    echo Location: http://hack.com/cgi-bin/index.cgi
    echo
    echo -n P > /tmp/state
    cat /tmp/timewarp > /tmp/timewarp.value
    if [ $DOCKER = true ]
    then
	sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
    else
	sh -c "sleep .5; pkill mitmproxy" > /dev/null 2>&1 &
    fi
    exit 0
fi

if [ "$PATH_INFO" = "/S" ]
then
    echo Content-type: text/html
    echo Location: http://hack.com/cgi-bin/index.cgi
    echo
    echo -n S > /tmp/state
    echo -n 0 > /tmp/timewarp.value
    if [ $DOCKER = true ]
    then
	sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
    else
	sh -c "sleep .5; pkill mitmproxy" > /dev/null 2>&1 &
    fi
    exit 0
fi

if [ "$PATH_INFO" = "/T" ]
then
    echo Content-type: text/html
    echo Location: http://hack.com/cgi-bin/index.cgi
    echo
    echo -n T > /tmp/state
    exit 0
fi

# debug the time warp
if [ "$PATH_INFO" = "/D" ]
then
    echo Content-type: text/html
    echo Location: http://hack.com/cgi-bin/index.cgi
    echo
    echo -n D > /tmp/state
    exit 0
fi
