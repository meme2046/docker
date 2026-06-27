FROM superjump22/dontstarvetogether:latest

RUN apt update
RUN apt install -y tzdata netcat-openbsd iproute2

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" >/etc/timezone

RUN apt clean && rm -rf /var/lib/apt/lists/*
