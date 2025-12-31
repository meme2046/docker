FROM registry.cn-chengdu.aliyuncs.com/jusu/ub24:latest

# RUN apt update
# RUN apt install -y libopencv-dev
# RUN apt clean && rm -rf /var/lib/apt/lists/*

# https://pypi.org/simple
# https://mirrors.cloud.tencent.com/pypi/simple
RUN uv python install cpython-3.10.19-linux-x86_64-gnu && uv python pin cpython-3.10.19-linux-x86_64-gnu
RUN uv tool install pymecli -i https://pypi.org/simple
RUN uv tool upgrade --all -i https://pypi.org/simple
RUN uv cache clean

# # 复制脚本并赋予权限
COPY ./files/cmd.sh /files/cmd.sh
RUN chmod +x /files/cmd.sh

EXPOSE 80 443

CMD ["/files/cmd.sh"]
