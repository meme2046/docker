FROM ghcr.io/miracleeverywhere/dst-management-platform-api:v3.1.4

# 避免apt交互弹窗
ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386
RUN apt update
RUN apt install -y \
  tzdata \
  lib32gcc-s1 \
  lib32stdc++6 \
  libc6-i386 \
  libcurl4-gnutls-dev:i386

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

RUN apt clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/root/entry-point.sh"]
