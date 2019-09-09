FROM ubuntu:16.04
COPY dnsmasq.sh smbd.sh apache2.sh /
RUN apt-get update && \
    apt-get -y install dnsmasq samba apache2 && \
    rm -rf /var/lib/apt/lists/* && \
    echo "DNSMASQ_EXCEPT=lo" >> /etc/default/dnsmasq && \
    chmod 777 /dnsmasq.sh /smbd.sh /apache2.sh && \
    useradd user && \
    mkdir -p /ISO &&  \
    mkdir -p /Public &&  \
    sh -c "(echo pass; echo pass) | smbpasswd -a -s user"
