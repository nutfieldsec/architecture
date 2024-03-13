FROM docker.io/pandoc/latex

ENV CHROME_BIN="/usr/bin/chromium-browser" \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
    MERMAID_BIN="/usr/local/bin/run-mmdc" \
    PUPPETEER_EXECUTABLE_PATH="/usr/bin/chromium-browser"

RUN apk --no-cache --update add udev graphviz ttf-freefont \
    chromium chromium-chromedriver npm ghostscript bash && \
    npm install -g mermaid-filter @mermaid-js/mermaid-cli --unsafe-perm=true && \
    mkdir -p /filters && \
    wget -q -O- https://github.com/pandoc-ext/diagram/archive/refs/tags/v1.0.0.tar.gz | \
    tar -xz --strip-components=1 -C /filters && \
    printf '#!/bin/sh\nmmdc -p /etc/puppeteer-conf.json $@' > $MERMAID_BIN && \
    chmod +x $MERMAID_BIN

COPY ./puppeteer-conf.json /etc/puppeteer-conf.json

ENTRYPOINT ["/bin/bash", "-c"]