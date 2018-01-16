FROM ubuntu:latest
MAINTAINER tzhou "zhoutangxing@126.com"

ENV BASE_TOOLS wget curl vim nginx
ENV PYTHON python3 python3-dev build-essential python3-pip
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

RUN apt-get update -y \
    && mkdir -p ~/.pip \
    && mv $WORK_DIR/pip.conf ~/.pip \
    && apt-get install $INSTALL_TOOLS -y \
    && pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && apt-get purge -y

# Make port APP_PORT available to the world outside this container
EXPOSE $APP_PORT

ENTRYPOINT ["deploy_app.sh"]
CMD ["-n", "$APP_NAME"]
