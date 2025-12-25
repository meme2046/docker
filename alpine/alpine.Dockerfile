from alpine:latest

SHELL ["/bin/sh", "-c"]
RUN apk add --no-cache tzdata

RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo "Asia/Shanghai" > /etc/timezone

RUN apk add --no-cache curl git

RUN apk del tzdata \  
	&& apk cache clean \  
	&& rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

COPY files/endpoint.sh /files/endpoint.sh
COPY files/sig /files/sig

RUN chmod +x /files/endpoint.sh
RUN chmod +x /files/sig

ENTRYPOINT ["/files/endpoint.sh"]
CMD ["/files/sig"]
