from alpine:latest

SHELL ["/bin/sh", "-c"]
RUN apk add --no-cache tzdata curl git gcc g++
# musl-dev linux-headers

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" >/etc/timezone

RUN apk add --no-cache uv
RUN apk add --no-cache nodejs npm

RUN apk cache clean && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

ENV PATH=${PATH}:root/.local/bin

COPY files/endpoint.sh /files/endpoint.sh
COPY files/sig /files/sig

RUN chmod +x /files/sig

ENTRYPOINT ["/files/endpoint.sh"]
CMD ["/files/sig"]
