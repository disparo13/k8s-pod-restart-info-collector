FROM golang:1.25-alpine3.22 AS builder

RUN apk add --no-cache ca-certificates openssl && \
    update-ca-certificates

COPY go.* /
RUN go mod download
COPY *.go /
RUN CGO_ENABLED=0 go build -o /k8s-pod-restart-info-collector /

FROM alpine:3.22
COPY --from=builder /k8s-pod-restart-info-collector /k8s-pod-restart-info-collector
CMD ["/k8s-pod-restart-info-collector"]
