#!/bin/bash

run_browser jwm -display $DISPLAY &

if [[ -n "$PROXY_GET_CA" && -n "$PROXY_HOST" ]]; then
    curl -x "$PROXY_HOST:$PROXY_PORT"  "$PROXY_GET_CA" > /tmp/proxy-ca.pem

    mkdir -p $HOME/.pki/nssdb
    certutil -d $HOME/.pki/nssdb -N
    certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "Proxy" -i /tmp/proxy-ca.pem
fi

mkdir ~/.config/
mkdir ~/.config/google-chrome
touch ~/.config/google-chrome/First\ Run

# tunnel to localhost
run_browser socat tcp-listen:9222,fork tcp:localhost:9221 &

run_browser google-chrome --no-default-browser-check \
  --disable-component-update \
  --disable-popup-blocking \
  --disable-background-networking \
  --disable-background-timer-throttling \
  --disable-client-side-phishing-detection \
  --disable-default-apps \
  --disable-extensions \
  --disable-hang-monitor \
  --disable-prompt-on-repost \
  --disable-sync \
  --disable-translate \
  --disable-domain-reliability \
  --disable-renderer-backgrounding \
  --disable-infobars \
  --disable-translate \
  --metrics-recording-only \
  --no-first-run \
  --safebrowsing-disable-auto-update \
  --password-store=basic \
  --use-mock-keychain \
  --autoplay-policy=no-user-gesture-required  \
  --disable-features=site-per-process \
  --remote-debugging-port=9221 "$URL" &

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



