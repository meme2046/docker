FROM ghcr.io/astral-sh/uv:python3.10-alpine

ENV TZ=Asia/Shanghai
RUN apk add --no-cache tzdata build-base linux-headers \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN uv tool install cronapi-py
RUN uv tool upgrade --all
RUN uv cache clean

EXPOSE 80 443
