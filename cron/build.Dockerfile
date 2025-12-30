FROM golang:1.25-alpine AS builder

RUN apk add --no-cache nushell
RUN apk cache clean && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

ENV JOB_DIR=/go-job
ENV JOB_OUTPUT_DIR=/go-job-output
ENV WORKER_DIR=/cron-worker
ENV WORKER_OUTPUT_DIR=/cron-worker-output
RUN mkdir -p $JOB_OUTPUT_DIR
RUN mkdir -p $WORKER_OUTPUT_DIR

WORKDIR $JOB_DIR
COPY ./go-job .

RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct

RUN printf "🎯GO111MODULE: %s" "$(go env GO111MODULE)"
RUN echo "🎯GOPROXY: $(go env GOPROXY)"
RUN echo "🎯go version: $(go version)"

WORKDIR $JOB_DIR/jobs
COPY build.nu .
RUN chmod +x build.nu
RUN nu build.nu jobs

WORKDIR $WORKER_DIR
COPY ./cron-worker .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o "$WORKER_OUTPUT_DIR" main.go

RUN echo "📁$WORKER_OUTPUT_DIR" && ls $WORKER_OUTPUT_DIR
RUN echo "📁$JOB_OUTPUT_DIR" && ls $JOB_OUTPUT_DIR

FROM alpine:latest

WORKDIR /worker/go/
COPY --from=builder /go-job-output .
RUN chmod +x *
RUN echo "📁" && pwd && ls

WORKDIR /worker
COPY --from=builder /cron-worker-output .
RUN chmod +x *
COPY ./cron-worker/conf/ ./conf
RUN mkdir -p /worker/log
RUN echo "📁" && pwd && ls
