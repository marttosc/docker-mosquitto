FROM debian:jessie

MAINTAINER Gustavo Marttos <marttosc@gmail.com>

RUN apt-get update && apt-get install -y wget && \
	wget -q -O - https://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | gpg --import && \
	gpg -a --export 8277CCB49EC5B595F2D2C71361611AE430993623 | apt-key add - && \
	wget -q -O /etc/apt/sources.list.d/mosquitto-jessie.list http://repo.mosquitto.org/debian/mosquitto-jessie.list && \
	apt-get update && \
	apt-get install -y mosquitto && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	adduser --system --disabled-password --disabled-login mosquitto

RUN mkdir -p /mqtt/config /mqtt/data /mqtt/log

COPY config /mqtt/config

RUN chown -R mosquitto:mosquitto /mqtt

VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 9001

ADD entrypoint.sh /usr/bin/

ENTRYPOINT ["entrypoint.sh"]

CMD ["/usr/sbin/mosquitto", "-c", "/mqtt/config/mosquitto.conf"]

