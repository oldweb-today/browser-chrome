#!/usr/bin/env bash

if [[ -n "$DISPLAY" ]]; then
  run_forever jwm -display "$DISPLAY" &

  HEADLESS=""
else
  HEADLESS="--headless"
fi

if [[ -n "$PROXY_CA_FILE" && -f "$PROXY_CA_FILE" && -n "$PROXY_HOST" ]]; then
    rm -rf "$HOME/.pki/nssdb"
    mkdir -p "$HOME/.pki/nssdb"
    certutil -d "$HOME/.pki/nssdb" -N
    certutil -d "sql:$HOME/.pki/nssdb" -A -t "C,," -n "Proxy" -i "$PROXY_CA_FILE"
    rm "$PROXY_CA_FILE"
fi

mkdir ~/.config/
mkdir ~/.config/google-chrome
touch ~/.config/google-chrome/First\ Run

# tunnel to localhost
run_forever socat tcp-listen:9222,fork tcp:localhost:9221 &

extractChromeMajor() {
    : "${1#"${1%%[![:space:]]*}"}"  # strip leading whitespace
    : "${_%"${_##*[![:space:]]}"}"  # strip trailing whitespace
    : "${_/Google Chrome }"         # remove non version info
    : "${_:: 1}"                    # get first major
    printf '%s' "$_"
}

CARGS="--disable-features=site-per-process"
CMAJOR=$(extractChromeMajor "$(google-chrome --version)")

if [[ ${CMAJOR} -gt 6 ]]; then
    CARGS="--disable-backgrounding-occluded-windows \
  --disable-backing-store-limit \
  --disable-breakpad \
  --disable-features=site-per-process,TranslateUI,LazyFrameLoading,LazyImageLoading,BlinkGenPropertyTrees \
  --disable-gpu-process-crash-limit \
  --disable-ipc-flooding-protection \
  --enable-features=NetworkService,NetworkServiceInProcess \
  --force-color-profile=srgb \
  --no-pings \
  --no-user-gesture-required \
  --no-first-run"
fi

FLASH=/app/libpepflashplayer.so

if [[ ${CMAJOR} -ge 8 ]]; then
  CARGS="$CARGS --no-xshm"

  export QT_X11_NO_MITSHM=1
fi

# using fixed flag first for easier grep matching
run_forever google-chrome --no-default-browser-check \
  ${HEADLESS} ${CARGS} \
  --ppapi-flash-path=${FLASH} \
  --allow-outdated-plugins \
  --always-authorize-plugins \
  --allow-hidden-media-playback \
  --disable-popup-blocking \
  --disable-background-networking \
  --disable-background-timer-throttling \
  --disable-client-side-phishing-detection \
  --disable-default-apps \
  --disable-hang-monitor \
  --disable-prompt-on-repost \
  --disable-domain-reliability \
  --disable-renderer-backgrounding \
  --disable-infobars \
  --metrics-recording-only \
  --no-first-run \
  --translate-ranker-model-url=about:blank \
  --safebrowsing-disable-auto-update \
  --autoplay-policy=no-user-gesture-required  \
  --remote-debugging-port=9221 "$URL" &

pid=$!

count=0
wid=""

while [[ -z "$HEADLESS" && -z "$wid" ]]; do
    wid=$(wmctrl -l | grep " Google Chrome" | cut -f 1 -d ' ')
    if [ -n "$wid" ]; then
        echo "Chrome Found"
        break
    fi
    sleep 0.5
    ((count+=1))
    echo "Chrome Not Found"
    if [ $count -eq 6 ]; then
        echo "Restarting process"
        pkill -f "/chrome/chrome --no-def"
        count=0
    fi
done

wait $pid

