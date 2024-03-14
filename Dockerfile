FROM zeek/zeek:5.2 as builder

RUN apt-get update 

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
inetutils-ping

RUN ssh-keygen -t rsa -f /root/.ssh/example -N ""

RUN rm -f /root/.ssh/example
RUN rm -f /root/.ssh/example.pub

RUN cp /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/local/zeek/lib/
RUN cp /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/local/zeek/lib/

