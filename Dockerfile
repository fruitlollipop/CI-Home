FROM ubuntu:latest

WORKDIR /app

COPY . /app

RUN apt-get update -y \
    && apt-get install apt-utils -y \
    && apt-get install curl -y \
    && apt-get install nginx -y \
    && apt-get install python2.7 python2.7-dev build-essential python-pip -y \
    # && cd /usr/bin \
    # && ln -s python2 python \
    # && cd \
    && pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && apt-get purge -y

CMD ["bash", "/app/CI-Home/setup.sh"]