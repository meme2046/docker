FROM ghcr.io/astral-sh/uv:debian-slim

RUN apt update
RUN apt install -y tzdata curl git

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" >/etc/timezone

RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN uv python install cpython-3.10.20-linux-x86_64-gnu && uv python pin cpython-3.10.20-linux-x86_64-gnu

RUN uv tool install cronapi-py
RUN uv tool upgrade --all
RUN uv cache clean

EXPOSE 80 443
