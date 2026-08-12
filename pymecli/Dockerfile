FROM ghcr.io/astral-sh/uv:python3.10-alpine
ENV TZ=Asia/Shanghai
RUN apk add --no-cache tzdata build-base linux-headers \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN uv tool install pymecli
RUN uv tool upgrade --all
RUN uv cache clean

# # 复制脚本并赋予权限
COPY ./files/cmd.sh /files/cmd.sh
RUN chmod +x /files/cmd.sh

EXPOSE 80 443

CMD ["/files/cmd.sh"]
