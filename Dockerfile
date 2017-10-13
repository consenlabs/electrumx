FROM partlab/ubuntu-golang
MAINTAINER followtheart "followtheart@outlook.com"

RUN apt-get update 
RUN apt-get install -y software-properties-common --no-install-recommends 
RUN add-apt-repository -y ppa:jonathonf/python-3.6 
RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
       python3.6 python3.6-dev libleveldb-dev wget git \
       libssl-dev nano build-essential
RUN rm /usr/bin/python3 \
    && ln -s /usr/bin/python3.6 /usr/bin/python3 
RUN wget https://bootstrap.pypa.io/get-pip.py -O- | python3.6
RUN pip install scrypt 
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  \
    && mkdir /log /db /env /electrumx
COPY contrib /electrumx/contrib
COPY lib /electrumx/lib
COPY server /electrumx/server
COPY tests /electrumx/tests
COPY wallet /electrumx/wallet
COPY Dockerfile /electrumx/Dockerfile
COPY electrumx_rpc.py /electrumx/electrumx_rpc.py
COPY electrumx_server.py /electrumx/electrumx_server.py
COPY query.py /electrumx/query.py
COPY setup.py /electrumx/setup.py
RUN cd /electrumx 
RUN cp /electrumx/electrumx_server.py /electrumx_server.py
RUN cp /electrumx/electrumx_rpc.py /electrumx_rpc.py
RUN python3.6 /electrumx/setup.py install
    
VOLUME /db

ENTRYPOINT ["python3", "/electrumx/electrumx_server.py"]
