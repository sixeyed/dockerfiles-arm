FROM alpine:3.9

ARG DNSMASQ_VERSION="2.80-r3"

# https://pkgs.alpinelinux.org/packages?name=dnsmasq&branch=v3.9&arch=aarch64
RUN apk add --no-cache dnsmasq=$DNSMASQ_VERSION

EXPOSE 53/udp

ENTRYPOINT ["dnsmasq"]
CMD ["--keep-in-foreground", "--log-facility=-"]

COPY dnsmasq.conf /etc/dnsmasq.conf