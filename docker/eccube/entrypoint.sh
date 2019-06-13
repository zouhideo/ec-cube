#!/bin/sh
set -e

# リモートデバッグの設定は環境変数だけでは対応できないため動的に追記
xdebug=$(cat << EOS
xdebug.remote_host=$(ip route | awk 'NR==1 {print $3}')
xdebug.remote_port=${XDEBUG_PORT}
EOS
)
echo "${xdebug}" >> /usr/local/etc/php/conf.d/shop.ini

if [ -e "composer.json" ]; then
    composer install
fi

if [ -e "package.json" ]; then
    npm install
fi

if [ "${1#-}" != "$1" ]; then
    set -- apache2-foreground "$@"
fi

exec "$@"
