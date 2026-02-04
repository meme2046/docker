FROM ghcr.io/astral-sh/uv:debian-slim

SHELL ["/bin/sh", "-c"]
RUN apt update
RUN apt install -y tzdata curl git

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=${PATH}:root/.local/bin

COPY files/endpoint.sh /files/endpoint.sh
COPY files/sig /files/sig

RUN chmod +x /files/sig

ENTRYPOINT ["/files/endpoint.sh"]
CMD ["/files/sig"]
