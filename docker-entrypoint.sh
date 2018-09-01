#!/bin/sh

[[ -f "/opt/explorer/tmp/index.pid" ]] && rm -f /opt/explorer/tmp/index.pid

crond

su-exec ciquidus npm start

