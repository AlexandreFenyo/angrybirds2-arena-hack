#!/bin/zsh

timewarp=$(cat /tmp/timewarp)

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

    <b id="msg">XmessageY</b>
'

if [ $(cat /tmp/state) != 'S' ]
then
echo '
<a href="http://hack.com/cgi-bin/index.cgi/S">stop</a>
<a href="http://hack.com/cgi-bin/index.cgi/T">time warp</a>
'
else
echo '
<a href="http://hack.com/cgi-bin/index.cgi/P">play</a>
'    
fi

id

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
# a remettre avec docker
# sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
sh -c "sleep .5; pkill mitmproxy" > /dev/null 2>&1 &
exit 0
fi

if [ "$PATH_INFO" = "/S" ]
then
echo Content-type: text/html
echo Location: http://hack.com/cgi-bin/index.cgi
echo
echo -n S > /tmp/state
echo 0 > /tmp/timewarp.value
# a remettre avec docker
# sh -c "sleep .5; pkill python3.5" > /dev/null 2>&1 &
sh -c "sleep .5; pkill mitmproxy" > /dev/null 2>&1 &
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
