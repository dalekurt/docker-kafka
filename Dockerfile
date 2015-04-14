FROM

RUN apt-get update && \
    apt-get install -y wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q http://apache.mirrors.spacedump.net/kafka/0.8.1.1/kafka_2.8.0-0.8.1.1.tgz -O /tmp/kafka_2.8.0-0.8.1.1.tgz && \
    tar xfz /tmp/kafka_2.8.0-0.8.1.1.tgz -C /opt && \
    rm /tmp/kafka_2.8.0-0.8.1.1.tgz

ENV KAFKA_HOME /opt/kafka_2.8.0-0.8.1.1
ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh

# Supervisor config
ADD supervisor/kafka.conf /etc/supervisor/conf.d/kafka.conf

EXPOSE 9092

CMD ["supervisord", "-n"]
