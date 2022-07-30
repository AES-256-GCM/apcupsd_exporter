FROM golang:1.18-buster as builder

# Specify Git ref to use
ARG GIT_REF=v0.3.0

WORKDIR /opt/src

RUN git clone https://github.com/mdlayher/apcupsd_exporter.git .

RUN git checkout $GIT_REF &&\
    go build ./cmd/apcupsd_exporter

FROM alpine

RUN apk add --no-cache libc6-compat

WORKDIR /opt/exporter

COPY --from=builder /opt/src/apcupsd_exporter /opt/exporter/apcupsd_exporter

USER 1000

ENTRYPOINT [ "./apcupsd_exporter" ] 
