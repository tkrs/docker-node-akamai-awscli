FROM akamaiopen/cli as akamai

FROM node:12-alpine

COPY --from=akamai /usr/local/bin/akamai                          /usr/local/bin/akamai
COPY --from=akamai /cli/.akamai-cli/config                        /cli/.akamai-cli/
COPY --from=akamai /cli/.akamai-cli/cache                         /cli/.akamai-cli/
COPY --from=akamai /cli/.akamai-cli/src/cli-purge/cli.json        /cli/.akamai-cli/src/cli-purge/
COPY --from=akamai /cli/.akamai-cli/src/cli-purge/akamai-purge    /cli/.akamai-cli/src/cli-purge/

RUN apk -v --update add \
        python3 \
        py3-pip \
        curl \
        groff \
        less \
        mailcap \
        && \
    pip3 install --upgrade awscli python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/* && \
    aws --version

ENV AKAMAI_CLI_HOME=/cli

# VOLUME /root/.aws
# VOLUME /root/.edgerc
# VOLUME /cli
