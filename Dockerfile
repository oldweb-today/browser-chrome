FROM oldwebtoday/base-browser

USER root

ARG CHROME_DEB

COPY ./deb/$CHROME_DEB /tmp/$CHROME_DEB

COPY ./deb/$CHROME_DEB /var/cache/apt/archives/

RUN dpkg -i /tmp/$CHROME_DEB; apt-get update; apt-get install -fqqy && \
    rm -rf /var/lib/opts/lists/*
    #apt-get install -fqqy socat && \

COPY policy.json /etc/opt/chrome/policies/managed/policy.json

COPY ./flash/libpepflashplayer.so /app/libpepflashplayer.so

USER browser

WORKDIR /home/browser

COPY run.sh /app/run.sh

CMD ["/app/run.sh"]

LABEL wr.name="Chrome" \
      wr.os="linux" \
      wr.about="https://en.wikipedia.org/wiki/Google_Chrome" \
      wr.icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADJElEQVR4AT1TQ4AuRxD+qnrm/2et5/VurGf73eJkr7Ft23ZyiXHKKafYtvNsrM351d1V2Z2gjfrKRe7ndZhq2x6NmJ3DIbc66XqloVLGx5arc62qCmLazSWl39de3DOy7y7PFIZovF0EABIGPz5XxkuvGJeeN5pL7dDgTWrtBRCZqSKAajIB9BKbl6i84pH6y/snDjyY4oZbC0K/nHkSz7tiTLY+XdEQWfuOUT0aIgkCOgVVQDxNTkCVwLzRlEcn1F2ZPdDxTMiJBjvuMiUukG8N89zIBJaZA58vkGSzQGJCCsyBqvdOVUIV+rMwWL3ysJeH4wAAzmlrvvmGj/fMPWqsYG2xCYM4RtHMGqSPXAkYRa7nN2THesmExSGztwaYW1E9eDPAd9Cpz55b9V1t+s/VWwbr7/iyQ5WFZqxYiY62G/Fp93RMtQ3NfThi5AFg5DtExSVqAiH11K6+ZK6xpy9eF1p/6b7pxVq/f5iOTJWg++IncO8X07B9d4zdnQV8tasSc49ehKbgC0ByRJRSCrmC0/IFO/UtogIxpG8eXQGeewy+7JmBzEiMijKDilKDXH4C722bBtTMBwUOlDJKhgDSliBxOAHpvMPG2SX4tKwaxXkPRwQkEVSIAkmjBJQc//0Eq8oeUYUXoSKTwgvcibktw6gpitA34TEwOcuiYhx/+CAwsRGgNAChKbAI9gRw8qMG3O5J69PMumN0iF7qeQVXH3ce/thVhYCB2jlDKMs+BUgvwEUKeFJFe8Hqj0ke1G9quE+ZbgdgGRSO2SxaK6qxbvahiHOCofbf8dph+1EepaAqdhIdetH7AdyRMGj8pbbERfwtiOYCapk4yDlLWckjN5jHW0dZtDV59XlxBhqK6J/jsV9ZWmJirvuzlvcv6ozZ+pNUZKNCQyceUWBUfSRtM0Jpq/eqeY9/wRtzeTlpCuydMnfM7ZTaSSbt87sOcMauUCf3Q7Uv5zxVuRzf3RozxJEX9Fmn94+OuxXpNB9wk2ATkPxfznV/1bEYQteR7XLEH7Mqd8Z++XEl2dZ35k8gzunuQkG/Ly/jETCxOAUzBAD+BhTZxancWpFRAAAAAElFTkSuQmCC"

