FROM alpine:edge

MAINTAINER Peter Fontaine <peter.fontaine@reactiva.fr>

ARG DOL_VERSION="7.0.3"
ARG TIMEZONE="Europe/Paris"
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="Dolibarr" \
	  org.label-schema.description="Docker image for Dolibarr" \
	  org.label-schema.url="https://www.reactiva.fr/dolibarr/" \
	  org.label-schema.vcs-ref=$VCS_REF \
	  org.label-schema.vcs-url="https://github.com/reactivasoftware/dolibarrdocker" \
	  org.label-schema.vendor="SAS Reactiva Software" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.schema-version="1.0" \
	  fr.reactiva.label-docker.project="dolibarr" \
	  fr.reactiva.label-docker.version=$DOL_VERSION

ENV DOL_FQDN="" \
	DOL_HOST="" \
	SSL_CERTFILE="" \
	SSL_KEYFILE="" \
	SSL_CHAINFILE="" \
	SSL_METHOD="letsencrypt" \
	HOOK_PRESTART="" \
	HOOK_POSTSTART="" \
	HOOK_PREINSTALL="" \
	HOOK_POSTINSTALL="" \
	HOOK_PREUPDATE="" \
	HOOK_POSTUPDATE="" \
	MAIL_SERVER="" \
	MAXFILESIZE="20M"

RUN apk update \
	&& apk upgrade \
	&& apk add --update tzdata \
	&& cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
	&& echo "${TIMEZONE}" > /etc/timezone \
	&& apk add --update --no-cache \
	curl \
	unzip \
	apache2 \
	apache2-ssl \
	apache2-utils \
	php7 \
	php7-apache2 \
	php7-curl \
	php7-gd \
	php7-imap \
	php7-mysqli \
	php7-pgsql \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-zip \
	php7-session \
	php7-json \
	php7-openssl \
	php7-fileinfo \
	php7-gd \
	php7-bz2 \
	php7-imagick \
	php7-memcached \
	php7-pear \
	php7-mcrypt \
	php7-oauth \
	php7-xml \
	php7-ldap \
	logrotate \
	certbot \
	&& mkdir /builddir/ \
	&& curl -sL https://github.com/Dolibarr/dolibarr/archive/${DOL_VERSION}.zip > /builddir/dolibarr-${DOL_VERSION}.zip \
	&& addgroup -g 4269 dolibarr \
	&& adduser -D -u 4269 -G dolibarr dolibarr \
	&& mkdir /dolibarr \
	&& mkdir /dolibarr/documents \
	&& mkdir /certs \
	&& cd /builddir \
	&& unzip -q dolibarr-${DOL_VERSION}.zip \
	&& mv dolibarr-${DOL_VERSION}/* /dolibarr \
	&& chown -R dolibarr:dolibarr /dolibarr \
	&& echo "${DOL_VERSION}" > /dolibarr/documents/install.lock \
	&& chmod 444 /dolibarr/documents/install.lock \
	&& apk del tzdata \
	&& rm -rf /var/cache/apk/* \
	&& rm -rf /builddir \
	&& mkdir /scripts

ADD scripts/* /scripts/

RUN chmod +x /scripts/* \
	&& chown -R dolibarr:dolibarr /scripts

WORKDIR /scripts

USER dolibarr:dolibarr

EXPOSE 80 443

VOLUME /dolibarr/htdocs/custom \
	   /dolibarr/documents \
	   /dolibarr/htdocs/conf \
	   /var/logs/apache2/ \
	   /certs

CMD ["docker-entrypoint.sh"]
