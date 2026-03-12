FROM alpine:3.20

RUN apk add --no-cache openssh git bash

RUN adduser -D -s /bin/sh git \
  && mkdir -p /srv/git /home/git/.ssh /var/run/sshd \
  && chown -R git:git /srv/git /home/git

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

CMD ["/entrypoint.sh"]
