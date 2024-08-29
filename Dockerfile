FROM caddy:latest
WORKDIR /root
RUN mkdir -p /run/openrc/
RUN touch /run/openrc/softlevel
RUN apk add openrc
RUN apk add tailscale
RUN echo "Ensure the tailscale env TSKEY is set: $TSKEY"
RUN echo $'#!/bin/sh \n\
tailscaled > /tmp/tailscaled.log & \n\
sleep 3 \n\
tailscale up --auth-key=$TSKEY > /tmp/tailscaleup.log & \n\
sleep 1 \n\
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile' > /root/caddy-tailscale.sh

RUN chmod 0777 /root/caddy-tailscale.sh 
ENTRYPOINT ["/root/caddy-tailscale.sh"]
