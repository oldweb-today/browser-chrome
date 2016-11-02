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

#run_browser /app/ffmpeg -f pulse -i default -bufsize 32k -ac 1 -c:a libopus -min_frag_duration 500 -ab 12k -ar 12000 -listen 1 -f webm http://0.0.0.0:6082 &
run_browser /app/ffmpeg -re -f pulse -i default -bufsize 32k -ac 1 -c:a libopus -ab 32k -listen 1 -f segment -min_frag_duration 500 -f webm http://0.0.0.0:6082 &

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



