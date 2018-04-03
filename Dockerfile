# 3DCityDB Web Map Client Dockerfile ##########################################
#   Official website    https://www.3dcitydb.net
#   GitHub              https://github.com/3dcitydb/3dcitydb-web-map
###############################################################################
FROM    node:alpine
# Maintainers #################################################################
#       Bruno Willenborg
#       Son H. Nguyen
#       Chair of Geoinformatics
#       Department of Civil, Geo and Environmental Engineering
#       Technical University of Munich (TUM)
#       <b.willenborg@tum.de>
#       <son.nguyen@tum.de>
LABEL   maintainer1="Bruno Willenborg, Chair of Geoinformatics, Technical University of Munich (TUM) <b.willenborg@tum.de>" \
        maintainer2="Son H. Nguyen, Chair of Geoinformatics, Technical University of Munich (TUM) <son.nguyen@tum.de>"

# Setup 3DCityDB Web Map Client ###############################################
ARG     webmapclient_version='v1.4.0'
RUN     set -x && \
        BUILD_PACKAGES='ca-certificates git' && \
        apk update && apk add --no-cache --no-progress $BUILD_PACKAGES && \
        git clone -b "${webmapclient_version}" --depth 1 https://github.com/3dcitydb/3dcitydb-web-map.git /var/www && \
        cd /var/www && \
        rm -rf ./.git ./.gitignore ./LICENSE ./README.md ./build.xml \
                ./node_modules ./server.js ./theme && \
        mkdir -p /var/www/data && \
        apk del $BUILD_PACKAGES && \
        rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/
COPY    package.json ./
COPY    html/* ./
COPY    server.js ./
RUN     set -x && \
        npm install --production

#RUN    set -x && \
#       chown -R node:node /var/www/

VOLUME  /var/www/
#USER   node
#EXPOSE 8000
#CMD [ "node", "server.js", "--public"]

# Install Samba based on dperson/samba
# https://github.com/dperson/samba
RUN     apk --no-cache --no-progress upgrade && \
        apk --no-cache --no-progress add bash samba shadow && \
        adduser -D -G users -H -S -g 'Samba User' -h /tmp smbuser && \
        file="/etc/samba/smb.conf" && \
        sed -i 's|^;* *\(log file = \).*|   \1/dev/stdout|' $file && \
        sed -i 's|^;* *\(load printers = \).*|   \1no|' $file && \
        sed -i 's|^;* *\(printcap name = \).*|   \1/dev/null|' $file && \
        sed -i 's|^;* *\(printing = \).*|   \1bsd|' $file && \
        sed -i 's|^;* *\(unix password sync = \).*|   \1no|' $file && \
        sed -i 's|^;* *\(preserve case = \).*|   \1yes|' $file && \
        sed -i 's|^;* *\(short preserve case = \).*|   \1yes|' $file && \
        sed -i 's|^;* *\(default case = \).*|   \1lower|' $file && \
        sed -i '/Share Definitions/,$d' $file && \
        echo '   pam password change = yes' >>$file && \
        echo '   map to guest = bad user' >>$file && \
        echo '   usershare allow guests = yes' >>$file && \
        echo '   create mask = 0664' >>$file && \
        echo '   force create mode = 0664' >>$file && \
        echo '   directory mask = 0775' >>$file && \
        echo '   force directory mode = 0775' >>$file && \
        echo '   force user = smbuser' >>$file && \
        echo '   force group = users' >>$file && \
        echo '   follow symlinks = yes' >>$file && \
        echo '   load printers = no' >>$file && \
        echo '   printing = bsd' >>$file && \
        echo '   printcap name = /dev/null' >>$file && \
        echo '   disable spoolss = yes' >>$file && \
        echo '   socket options = TCP_NODELAY' >>$file && \
        echo '   strict locking = no' >>$file && \
        echo '   vfs objects = recycle' >>$file && \
        echo '   recycle:keeptree = yes' >>$file && \
        echo '   recycle:versions = yes' >>$file && \
        echo '   min protocol = SMB2' >>$file && \
        echo '' >>$file && \
        rm -rf /tmp/*

COPY    samba.sh /usr/bin/

EXPOSE  8000 137/udp 138/udp 139 445

#HEALTHCHECK --interval=60s --timeout=15s \
#             CMD smbclient -L '\\localhost\' -U 'guest%' -m SMB3

ENTRYPOINT [ "samba.sh" ]
