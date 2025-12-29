FROM golang:1.25-alpine AS builder

WORKDIR /go-job
COPY ./go-job .

RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct
# 💯🚀🎯🗂️📌📜
RUN echo "📁" && pwd && ls
RUN printf "🎯GO111MODULE: %s" "$(go env GO111MODULE)"
RUN echo "🎯GOPROXY: $(go env GOPROXY)"
RUN echo "🎯go version: $(go version)"

WORKDIR /go-job/jobs
RUN mkdir -p /build

RUN for item in *; do \
      if [ -d "$item" ]; then \
        echo "Building $item..."; \
        CGO_ENABLED=0 GOOS=linux go build -o "/build/$item" "./$item/."; \
      fi; \
    done

RUN echo "🗂️/build" && ls /build

FROM alpine:latest
WORKDIR /bin/go/

COPY --from=builder /build .

RUN chmod +x *

RUN echo "📁" && pwd && ls

WORKDIR /bin

# CMD ["main"]