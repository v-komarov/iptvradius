#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM centos:latest


RUN yum update -y \
	&& yum install mc -y \
	&& mkdir -p /opt/oracle \
	&& yum install libaio -y \
	&& curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" \
	&& python get-pip.py \
	&& python -m pip install cx_Oracle --upgrade \
	&& yum install MySQL-python -y \
	&& yum install unzip -y

COPY ./instantclient-basic-linux.x64-11.2.0.4.0.zip /opt/oracle/
COPY ./iptv_to_rad.py /
COPY ./myloop.sh /

RUN cd /opt/oracle \
	&& unzip instantclient-basic-linux.x64-11.2.0.4.0.zip \
	&& chmod +x /iptv_to_rad.py \
        && chmod +x /myloop.sh \
	&& sh -c "echo /opt/oracle/instantclient_11_2 > /etc/ld.so.conf.d/oracle-instantclient.conf" \
	&& ldconfig \
	&& export LD_LIBRARY_PATH=/opt/oracle/instantclient_11_2 \
	&& export PATH=$PATH:$LD_LIBRARY_PATH


CMD ["/myloop.sh"]
