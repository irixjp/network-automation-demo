FROM alpine:3.20

RUN apk add --no-cache openssh iputils bash

RUN adduser -D -s /bin/sh demo \
  && echo "demo:demo" | chpasswd \
  && mkdir -p /var/run/sshd

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]
