# Kafka for Ubuntu 14.04
#
# GitHub - http://github.com/dalekurt/docker-kafka
# Docker Hub - http://hub.docker.com/u/dalekurt/kafka
# Twitter - http://www.twitter.com/dalekurt

FROM dalekurt/java7

MAINTAINER Dale-Kurt Murray "dalekurt.murray@gmail.com"

ENV KAFKA_VERSION 0.8.2.1 
ENV SCALA_VERSION 2.10

# Basic environment setup
RUN apt-get update && \
    apt-get install -y wget supervisor dnsutils curl && \
    rm -rf /var/lib/apt/lists/*

# Downloading and install Kafka    
ADD scripts/download-kafka.sh /tmp/download-kafka.sh
RUN /tmp/download-kafka.sh
RUN tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

VOLUME ["/kafka"]

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh
ADD scripts/broker-list.sh /usr/bin/broker-list.sh

# Supervisor config
ADD supervisor/kafka.conf /etc/supervisor/conf.d/kafka.conf

EXPOSE 9092

CMD ["supervisord", "-n"]
