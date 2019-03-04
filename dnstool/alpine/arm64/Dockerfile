FROM golang:1.11-alpine3.9 AS builder

COPY main.go .
RUN CGO_ENABLED=0 go build -o /dnstool

# minio
FROM alpine:3.9

ENTRYPOINT ["/usr/bin/dnstool"]
CMD ["-host", "docker.com", "-fmt", "You'll find {{.Host}} at {{range .Ips}} {{.}} {{end}}"]

COPY --from=builder /dnstool /usr/bin/dnstool
RUN chmod +x /usr/bin/dnstool