FROM golang:1.11-alpine3.9 AS builder

ENV GOPATH=/go \
    CGO_ENABLED=0

RUN apk add --no-cache git && \
    go get -v -d github.com/minio/minio && \
    cd /go/src/github.com/minio/minio && \
    go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" && \
    go build -ldflags "-s -w" -o /usr/bin/healthcheck dockerscripts/healthcheck.go 

# minio
FROM alpine:3.9

ENV MINIO_UPDATE off
ENV MINIO_ACCESS_KEY_FILE=access_key \
    MINIO_SECRET_KEY_FILE=secret_key

EXPOSE 9000
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["minio"]

HEALTHCHECK --interval=1m CMD healthcheck

RUN apk add --no-cache ca-certificates 'curl>7.61.0' && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

COPY --from=builder /go/bin/minio /usr/bin/minio
COPY --from=builder /usr/bin/healthcheck /usr/bin/healthcheck
COPY docker-entrypoint.sh /usr/bin/