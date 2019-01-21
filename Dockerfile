FROM buildpack-deps:jessie-scm
MAINTAINER EvanYang <evanyang1120@163.com>

ENV DEBIAN_FRONTEND noninteractive

ENV VERSION 8
ENV UPDATE 202
ENV BUILD 08
ENV SIG 1961070e4c9b4e26a04e7f5a083f551e

ENV JRE_HOME /usr/lib/jvm/jre-${VERSION}-oracle
ENV LANG C.UTF-8

RUN apt-get update && apt-get install ca-certificates curl \
	-y --no-install-recommends && \
	curl --silent --location --retry 3 --cacert /etc/ssl/certs/GeoTrust_Global_CA.pem \
	--header "Cookie: oraclelicense=accept-securebackup-cookie;" \
	http://download.oracle.com/otn-pub/java/jdk/"${VERSION}"u"${UPDATE}"-b"${BUILD}"/"${SIG}"/jre-"${VERSION}"u"${UPDATE}"-linux-x64.tar.gz \
	| tar xz -C /tmp && \
	mkdir -p /usr/lib/jvm && mv /tmp/jre1.${VERSION}.0_${UPDATE} "${JAVA_HOME}" && \
	apt-get autoclean && apt-get --purge -y autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY simsun.ttc ${JRE_HOME}/lib/fonts
COPY /JCE8 ${JRE_HOME}/lib/security

RUN update-alternatives --install "/usr/bin/java" "java" "${JRE_HOME}/bin/java" 1 && \
	update-alternatives --install "/usr/bin/javaws" "javaws" "${JRE_HOME}/bin/javaws" 1 && \
	update-alternatives --set java "${JRE_HOME}/bin/java" && \
	update-alternatives --set javaws "${JRE_HOME}/bin/javaws"
