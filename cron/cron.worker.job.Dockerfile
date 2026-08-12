FROM golang:alpine AS builder
ENV TZ=Asia/Shanghai
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
COPY ./files/build.nu .
RUN chmod +x build.nu
RUN nu build.nu jobs

WORKDIR $WORKER_DIR
COPY ./cron-worker .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o "$WORKER_OUTPUT_DIR" main.go

RUN echo "📁$WORKER_OUTPUT_DIR" && ls $WORKER_OUTPUT_DIR
RUN echo "📁$JOB_OUTPUT_DIR" && ls $JOB_OUTPUT_DIR

FROM ghcr.io/astral-sh/uv:python3.10-alpine
ENV TZ=Asia/Shanghai
RUN apk add --no-cache tzdata build-base linux-headers \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN uv tool install pymecli
RUN uv tool upgrade --all
RUN uv cache clean

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

CMD ["./main"]
