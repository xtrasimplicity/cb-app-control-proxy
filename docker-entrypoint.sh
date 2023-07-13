#!/bin/bash

http_config=$(cat <<EOF
  server {
    listen 80;

    location / {
     add_header Content-Type text/plain;
     return 200 "";
    }

    location /hostpkg {
      proxy_set_header Host \$host;
      proxy_pass https://${CB_APP_CONTROL_SERVER}:443/hostpkg;
    }

    location /css {
      proxy_set_header Host \$host;
      proxy_pass https://${CB_APP_CONTROL_SERVER}:443/css;
    }

    location /js {
     proxy_set_header Host \$host;
      proxy_pass https://${CB_APP_CONTROL_SERVER}:443/js;
    }

    location /fonts {
      proxy_set_header Host \$host;
      proxy_pass https://${CB_APP_CONTROL_SERVER}:443/fonts;
    }
  }
EOF
)

stream_config=$(cat <<EOF
  server {
    listen 41002;
    proxy_pass ${CB_APP_CONTROL_SERVER}:41002;
  }
EOF
)

echo $http_config > /etc/nginx/conf.d/default.conf
mkdir -p /etc/nginx/stream.conf.d
echo $stream_config > /etc/nginx/stream.conf.d/default.conf
echo "stream { include /etc/nginx/stream.conf.d/*.conf; }" >> /etc/nginx/nginx.conf

exec $@