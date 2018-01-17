FROM ubuntu:latest
MAINTAINER tzhou "zhoutangxing@126.com"

ENV BASE_TOOLS wget curl vim nginx
ENV PYTHON python3 python3-dev libmysqlclient-dev build-essential python3-pip
ARG INSTALL_TOOLS
ENV INSTALL_TOOLS $BASE_TOOLS $PYTHON $INSTALL_TOOLS
ARG WORK_DIR=/app 
ARG APP_PORT=8080

WORKDIR $WORK_DIR
COPY deploy_app.sh /usr/local/bin/
COPY pip.conf $WORK_DIR
COPY requirements.txt $WORK_DIR
COPY nginx $WORK_DIR
COPY uwsgi.ini $WORK_DIR

RUN sed -Ei 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
	&& apt-get update -y \
	&& chmod 755 /usr/local/bin/deploy_app.sh \
	&& apt-get install $INSTALL_TOOLS -y \
	&& mkdir -p ~/.pip \
	&& mv $WORK_DIR/pip.conf ~/.pip \
	&& pip3 install --upgrade pip setuptools wheel \
	&& pip3 install -r requirements.txt \
	&& apt-get purge -y

# Make port APP_PORT available to the world outside this container
EXPOSE $APP_PORT

ENTRYPOINT ["deploy_app.sh"]
CMD ["-n"]
