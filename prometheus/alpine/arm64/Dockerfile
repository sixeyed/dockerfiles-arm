FROM debian:9.7-slim AS installer

ARG PROMETHEUS_VERSION="2.8.1"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl

WORKDIR /download
RUN curl -L https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-arm64.tar.gz \
    | tar xvz -C /download --strip-components 1


# Prometheus
FROM alpine:3.9 

COPY --from=installer /download/prometheus              /bin/prometheus
COPY --from=installer /download/promtool                /bin/promtool
COPY --from=installer /download/prometheus.yml          /etc/prometheus/prometheus.yml
COPY --from=installer /download/console_libraries/      /etc/prometheus/
COPY --from=installer /download/consoles/               /etc/prometheus/

EXPOSE     9090
VOLUME     /prometheus

ENTRYPOINT ["/bin/prometheus", \
            "--storage.tsdb.path=/prometheus", \
            "--web.console.libraries=/etc/prometheus/console_libraries", \
            "--web.console.templates=/etc/prometheus/consoles" ]

CMD ["--config.file=/etc/prometheus/prometheus.yml"]