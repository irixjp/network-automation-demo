FROM lscr.io/linuxserver/openssh-server:latest

RUN apk add --no-cache git python3 ca-certificates \
  && git clone https://github.com/upa/deadman.git /opt/deadman \
  && apk del git

