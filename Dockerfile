FROM debian:wheezy
MAINTAINER erikreed

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
						ant \
            curl \
						gcc \
						g++ \
						build-essential \
						libkrb5-dev \
						libmysqlclient-dev \
						libssl-dev \
						libsasl2-dev \
						libsasl2-modules-gssapi-mit \
						libsqlite3-dev \
						libtidy-0.99-0 \
						libxml2-dev \
						libxslt-dev \
						maven \
						libldap2-dev \
						python-dev  \
						python-simplejson \
						python-setuptools \
						openjdk-7-jdk \
	&& apt-get clean \
  && rm -rf /var/lib/apt/lists/*
	
ENV HUE_VERSION release-3.8.1
WORKDIR /opt/hue

RUN curl -k -SL "https://github.com/cloudera/hue/archive/$HUE_VERSION.tar.gz" \
	| tar -xzf - -C /opt/hue --strip-components=1

RUN make apps && rm -rf /root/.m2 && useradd hue -r && chown -R hue:hue /opt/hue/

VOLUME /opt/hue/desktop/

EXPOSE 9999 8000

COPY supervisord-hue.conf /etc/supervisor/conf.d/supervisord-hue.conf
CMD /opt/hue/build/env/bin/supervisor

