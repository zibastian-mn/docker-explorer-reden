FROM alpine:latest
MAINTAINER Zibastian <Discord: @zibastian>

RUN apk add -U --no-cache dcron nodejs npm curl su-exec python

ARG usr=ciquidus
RUN addgroup -g 900 ${usr} && \
    adduser -D -u 900 -G ${usr} ${usr}

COPY ./ciquidus /opt/explorer
RUN chown -R ${usr}:${usr} /opt/explorer

RUN cd /opt/explorer && su-exec ${usr} npm install --production

RUN echo "#* * * * *       cd /opt/explorer && node scripts/sync.js index update" > /etc/crontabs/${usr}
RUN echo "#*/2 * * * *       cd /opt/explorer && node scripts/sync.js market" >> /etc/crontabs/${usr}
RUN echo "#*/5 * * * *       cd /opt/explorer && node scripts/peers.js" >> /etc/crontabs/${usr}

COPY ./docker-entrypoint.sh /usr/bin/docker-entrypoint
RUN chmod +x /usr/bin/docker-entrypoint

CMD ["docker-entrypoint"]

WORKDIR /opt/explorer

EXPOSE 3001/tcp
