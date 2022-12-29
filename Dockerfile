### Build section
FROM amd64/alpine

COPY run.sh /app/run.sh

RUN apk add curl jq bash && \
    chmod +x /app/run.sh

WORKDIR /app

ENTRYPOINT ["/bin/bash", "run.sh"]