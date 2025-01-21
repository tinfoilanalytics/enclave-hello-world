FROM ghcr.io/tinfoilanalytics/nitro-attestation-shim:v0.2.1 AS shim

FROM golang:1.23.3 AS build

COPY main.go .
RUN CGO_ENABLED=0 go build -o /app main.go

FROM alpine:3

RUN apk add iproute2

COPY --from=shim /nitro-attestation-shim /nitro-attestation-shim
COPY --from=build /app /app

ENTRYPOINT ["/nitro-attestation-shim", "-e", "tls@tinfoil.sh", "-u", "80", "--", "/app"]
