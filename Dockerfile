FROM ubuntu:latest

WORKDIR /app

COPY . /app

RUN apt-get update -y \
    && apt-get install apt-utils -y \
    && apt-get install curl -y \
    && apt-get install vim -y \
    && apt-get install nginx -y \
    && apt-get install python2.7 python2.7-dev build-essential python-pip -y \
    && pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt \
    && apt-get purge -y

# Make port 80, 8082 available to the world outside this container
EXPOSE 80
EXPOSE 8082

CMD ["bash", "/app/setup.sh"]