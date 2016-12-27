FROM oldwebtoday/base-browser

#RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
#    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
#    && apt-get update && apt-get install -y \
#    google-chrome-stable libnss3-tools jwm \
#    && rm -rf /var/lib/apt/lists/*

ENV CHROME_DEB google-chrome-stable_53.0.2785.143-1_amd64.deb

COPY $CHROME_DEB /tmp/$CHROME_DEB

COPY $CHROME_DEB /var/cache/apt/archives/

RUN dpkg -i /tmp/$CHROME_DEB; apt-get update; apt-get install -fqqy && \
    apt-get install wmctrl && \
    rm -rf /var/lib/opts/lists/*

USER browser

COPY run.sh /app/run.sh

RUN sudo chmod a+x /app/run.sh

WORKDIR /home/browser

CMD /app/entry_point.sh /app/run.sh

LABEL wr.name="Chrome" \
      wr.version="53" \
      wr.os="linux" \
      wr.release="2016-09-24" \
      wr.about="https://en.wikipedia.org/wiki/Google_Chrome" \
      wr.caps.flash="1" \
      wr.icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADJElEQVR4AT1TQ4AuRxD+qnrm/2et5/VurGf73eJkr7Ft23ZyiXHKKafYtvNsrM351d1V2Z2gjfrKRe7ndZhq2x6NmJ3DIbc66XqloVLGx5arc62qCmLazSWl39de3DOy7y7PFIZovF0EABIGPz5XxkuvGJeeN5pL7dDgTWrtBRCZqSKAajIB9BKbl6i84pH6y/snDjyY4oZbC0K/nHkSz7tiTLY+XdEQWfuOUT0aIgkCOgVVQDxNTkCVwLzRlEcn1F2ZPdDxTMiJBjvuMiUukG8N89zIBJaZA58vkGSzQGJCCsyBqvdOVUIV+rMwWL3ysJeH4wAAzmlrvvmGj/fMPWqsYG2xCYM4RtHMGqSPXAkYRa7nN2THesmExSGztwaYW1E9eDPAd9Cpz55b9V1t+s/VWwbr7/iyQ5WFZqxYiY62G/Fp93RMtQ3NfThi5AFg5DtExSVqAiH11K6+ZK6xpy9eF1p/6b7pxVq/f5iOTJWg++IncO8X07B9d4zdnQV8tasSc49ehKbgC0ByRJRSCrmC0/IFO/UtogIxpG8eXQGeewy+7JmBzEiMijKDilKDXH4C722bBtTMBwUOlDJKhgDSliBxOAHpvMPG2SX4tKwaxXkPRwQkEVSIAkmjBJQc//0Eq8oeUYUXoSKTwgvcibktw6gpitA34TEwOcuiYhx/+CAwsRGgNAChKbAI9gRw8qMG3O5J69PMumN0iF7qeQVXH3ce/thVhYCB2jlDKMs+BUgvwEUKeFJFe8Hqj0ke1G9quE+ZbgdgGRSO2SxaK6qxbvahiHOCofbf8dph+1EepaAqdhIdetH7AdyRMGj8pbbERfwtiOYCapk4yDlLWckjN5jHW0dZtDV59XlxBhqK6J/jsV9ZWmJirvuzlvcv6ozZ+pNUZKNCQyceUWBUfSRtM0Jpq/eqeY9/wRtzeTlpCuydMnfM7ZTaSSbt87sOcMauUCf3Q7Uv5zxVuRzf3RozxJEX9Fmn94+OuxXpNB9wk2ATkPxfznV/1bEYQteR7XLEH7Mqd8Z++XEl2dZ35k8gzunuQkG/Ly/jETCxOAUzBAD+BhTZxancWpFRAAAAAElFTkSuQmCC"

