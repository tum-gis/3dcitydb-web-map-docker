# 3DCityDB Web Map Client Dockerfile ###########################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb/3dcitydb-web-map
###############################################################################
# Base image
ARG baseimage_tag='14-alpine'
FROM node:${baseimage_tag}
# Maintainer ##################################################################
#   Bruno Willenborg
#   Chair of Geoinformatics
#   Department of Civil, Geo and Environmental Engineering
#   Technical University of Munich (TUM)
#   <b.willenborg@tum.de>
MAINTAINER Bruno Willenborg, Chair of Geoinformatics, Technical University of Munich (TUM) <b.willenborg@tum.de>

# Setup 3DCityDB Web Map Client ###############################################
ARG webmapclient_version='v1.9.0'
RUN set -x && \
  apk update && \
  apk add --no-cache --virtual .fetch-deps openssl git && \
  git clone -b "${webmapclient_version}" --depth 1 \
    https://github.com/3dcitydb/3dcitydb-web-map.git /var/www && \
  cd /var/www && \
  rm -rf .git .gitignore LICENSE README.md build.xml \
    node_modules server.js && \  
  mkdir -p /var/www/data && \
  apk del .fetch-deps

WORKDIR /var/www/  
COPY package.json ./
COPY html/* ./
COPY server.js ./
RUN set -x \
  && npm install --production

RUN set -x \
  && chown -R node:node /var/www/

VOLUME /var/www/
USER node
EXPOSE 8000
CMD [ "node", "server.js", "--public"]
