FROM debian

# Actualización del sistema y instalación de paquetes principales
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    macchanger \
    iw \
    sudo \
    libcurl4-openssl-dev \
    curl \
    libz-dev \
    module-assistant \
    libssl-dev \
    libnl-genl-3-dev \
    libnl-3-dev \
    pkg-config \
    libsqlite3-dev \
    git \
    hostapd \
    dnsmasq \
    kmod \
    make \
    g++ \
    wpasupplicant \
    apache2 \
    php \
    iproute2 \
    net-tools \
    iptables \
    --no-install-recommends \
    && apt-mark hold python3-impacket

# Instalación de paquetes adicionales
RUN apt-get install -y \
    inetutils-ping \
    isc-dhcp-client 
    #smbmap 

# Limpieza del sistema
RUN sudo apt-get --yes autoremove && \
    sudo apt-get autoclean && \
    sudo apt-get clean

# Copia de archivos y configuraciones
COPY config/wlan_config_clients /root/
COPY config/certs/ /root/certs/
COPY config/mgtClient/ /root/mgtClient/
COPY config/openClient/ /root/openClient/
COPY config/pskClient/ /root/pskClient/
COPY config/wpa3Client/ /root/wpa3Client/
COPY config/wepClient /root/wepClient
COPY config/connectINET.sh /root/
COPY config/html /var/www/html/
RUN rm /var/www/html/index.html
COPY config/ns-inet.sh /root/
COPY config/startClients.sh /root/
COPY config/cronClients.sh /root/

# Configuración específica
RUN update-rc.d apache2 defaults

# Cambio de nombre de archivos
RUN cp /sbin/wpa_supplicant /sbin/wpa_wifichallenge_supplicant && \
    cp /sbin/dhclient /sbin/dhclien-wifichallenge

# Ejecución final del contenedor
CMD ["/bin/bash", "/root/ns-inet.sh"]
