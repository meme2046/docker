FROM registry.cn-chengdu.aliyuncs.com/jusu/ub24:latest

RUN apt install -y libopencv-dev
RUN apt clean && rm -rf /var/lib/apt/lists/*

RUN apk add --no-cache tzdata \ 
curl \
	git \
	python \
	trzsz \
	mkcert

RUN RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&
	echo "Asia/Shanghai" >/etc/timezone

# https://pypi.org/simple
# https://mirrors.cloud.tencent.com/pypi/simple
RUN uv tool install pymecli -i https://mirrors.cloud.tencent.com/pypi/simple
RUN uv tool upgrade --all -i https://mirrors.cloud.tencent.com/pypi/simple

# # 复制脚本并赋予权限
COPY ./files/cmd.sh /files/cmd.sh
RUN chmod +x /files/cmd.sh

EXPOSE 80 443

CMD ["/files/cmd.sh"]
