FROM dalekurt/java7

MAINTAINER Dale-Kurt Murray "dalekurt.murray@gmail.com"

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.10"

RUN apt-get update && \
    apt-get install -y wget supervisor dnsutils curl && \
    rm -rf /var/lib/apt/lists/*
    
ADD scripts/download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

#RUN    wget -q http://apache.mirrors.spacedump.net/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
#    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \
#    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh
ADD scripts/broker-list.sh /usr/bin/broker-list.sh

# Supervisor config
ADD supervisor/kafka.conf /etc/supervisor/conf.d/kafka.conf

EXPOSE 9092

CMD ["supervisord", "-n"]
