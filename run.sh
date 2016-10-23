#!/bin/bash

#fluxbox -display $DISPLAY -log /tmp/fluxbox.log &
run_browser jwm -display $DISPLAY &

if [[ -n "$PROXY_GET_CA" ]]; then
    curl -x "$PROXY_HOST:$PROXY_PORT"  "$PROXY_GET_CA" > /tmp/proxy-ca.pem

    mkdir -p $HOME/.pki/nssdb
    certutil -d $HOME/.pki/nssdb -N
    certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "Proxy" -i /tmp/proxy-ca.pem
fi

mkdir ~/.config/
mkdir ~/.config/google-chrome
touch ~/.config/google-chrome/First\ Run

run_browser google-chrome --no-default-browser-check --disable-popup-blocking --disable-background-networking --disable-client-side-phishing-detection --disable-component-update --safebrowsing-disable-auto-update "$URL" &


pid=$!

count=0
wid=""

while [ -z "$wid" ]; do
    wid=$(wmctrl -l | grep " Google Chrome" | cut -f 1 -d ' ')
    if [ -n "$wid" ]; then
        echo "Chrome Found"
        break
    fi
    sleep 0.5
    count=$[$count + 1]
    echo "Chrome Not Found"
    if [ $count -eq 6 ]; then
        echo "Restarting process"
        kill $(ps -ef | grep "/chrome/chrome --no-def" | awk '{ print $2 }')
        count=0
    fi
done



