FROM zeek/zeek:5.2 as builder

RUN apt-get update 

#downloading necessary packages
RUN apt-get install -y --no-install-recommends nano \
iproute2 \
openssh-client \
rsync \
cmake \ 
make \ 
gcc \ 
g++ \ 
flex \
libfl-dev \
bison \
libpcap-dev \
libssl-dev \
python3 \
python3-dev \
swig \
zlib1g-dev \
inetutils-ping \
cron \
netcat

#creating a ssh keypair and then deleting it so that the .ssh folder is created for us
RUN ssh-keygen -t rsa -f /root/.ssh/example -N ""
RUN rm -f /root/.ssh/example
RUN rm -f /root/.ssh/example.pub

#copying missing files that Zeek needs to run to the correct folder 
RUN cp /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/local/zeek/lib/
RUN cp /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/local/zeek/lib/


COPY ${PWD}/cron/Expedited_Delivery_to_Graylog.sh /cron_job.sh
RUN chmod 755 cron_job.sh
RUN echo "59 * * * * bash /cron_job.sh" | crontab -
