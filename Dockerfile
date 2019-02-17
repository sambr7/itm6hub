FROM centos:7
MAINTAINER Samuel Januario <samuel.januario01@gmail.com>

COPY entrypoint.sh /entrypoint.sh
COPY ms_install.txt /ms_install.txt
COPY ms_config.txt /ms_config.txt
COPY  ITM_V6.3.0.7_BASE_LINUX_64_EN.tar.gz /ITM_V6.3.0.7_BASE_LINUX_64_EN.tar.gz

# Add dependencies
RUN yum --setopt=tsflags=nodocs -y install tar libstdc++.i686 compat-libstdc++-33.i686 glibc.i686 libgcc.i686 nss-softokn-freebl hostname compat-libstdc++-33 compat-libstdc++-296 libXmu libXtst openmotif22 openmotif dejavu-fonts-common xauth libaio ksh &&  rm -rf /var/cache/yum/* && yum clean all \
    && mkdir -p /tmp/itm_install/base \
    && tar -xvf /ITM_V6.3.0.7_BASE_LINUX_64_EN.tar.gz -C /tmp/itm_install/base \
    && cd /tmp/itm_install/base \
    && setarch $(uname -m) --uname-2.6 /tmp/itm_install/base/install.sh -q -h /opt/IBM/ITM -p /ms_install.txt \
    && rm -rf /tmp/itm_install && rm -rf /ITM_V6.3.0.7_BASE_LINUX_64_EN.tar.gz \
    && chmod +x /entrypoint.sh
VOLUME [ "/opt/IBM/ITM/" ]
WORKDIR /opt/IBM/ITM/bin
EXPOSE 1918/tcp
EXPOSE 3660/tcp
EXPOSE 3661/tcp
EXPOSE 1920/tcp
ENTRYPOINT [ "/entrypoint.sh" ]
