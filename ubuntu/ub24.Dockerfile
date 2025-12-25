FROM ubuntu:latest

SHELL ["/bin/bash", "-c"]
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone
RUN apt update

RUN apt install -y \
	curl \
	git \
	build-essential

RUN apt clean && rm -rf /var/lib/apt/lists/*

#  安装brew
RUN eval "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
ENV PATH=${PATH}:root/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin

RUN brew install \
	uv \
	gcc \
	trzsz \
	mkcert

RUN brew install node@24
RUN brew link --force --overwrite node@24 && brew cleanup

RUN uv tool install cowsay

COPY ./files/endpoint.sh /files/endpoint.sh
COPY ./files/sig /files/sig

RUN chmod +x /files/sig

ENTRYPOINT ["/files/endpoint.sh"]
CMD ["/files/sig"]
