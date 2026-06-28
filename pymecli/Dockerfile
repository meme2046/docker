FROM ghcr.io/astral-sh/uv:debian-slim

RUN apt update
RUN apt install -y tzdata curl git

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN uv python install cpython-3.10.20-linux-x86_64-gnu && uv python pin cpython-3.10.20-linux-x86_64-gnu
# RUN uv tool install pymecli -i https://mirrors.cloud.tencent.com/pypi/simple
# RUN uv tool upgrade --all -i https://mirrors.cloud.tencent.com/pypi/simple
RUN uv tool install pymecli
RUN uv tool upgrade --all
RUN uv cache clean

# # 复制脚本并赋予权限
COPY ./files/cmd.sh /files/cmd.sh
RUN chmod +x /files/cmd.sh

EXPOSE 80 443

CMD ["/files/cmd.sh"]
