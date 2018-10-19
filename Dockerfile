FROM jenkins/jnlp-slave:3.19-1

ARG DOCKER_GID=497

USER root

ENV DOCKER_VERSION "18.03.1-ce"


RUN apt-get -y update \
    && apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" \
    && apt-get -y update \
    && apt-get -y install docker-ce

# INSTALL NODE

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -

RUN apt-get install nodejs
RUN npm install -g npm@5.7.1

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list \
    && apt-get -y update \
    && apt-get install -y mongodb-server \
    && mkdir /data \
    && mkdir /data/db \
    && mkdir /data/db/log

# SONARQUBE

RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip \
    && unzip sonar-scanner-cli-3.2.0.1227-linux.zip

RUN mv sonar-scanner-3.2.0.1227-linux /opt/sonar \
    && ls /opt/sonar \
    && export PATH=$PATH:/opt/sonar/bin \
    && chmod u+x -R /opt/sonar/bin \
    && rm /opt/sonar/conf/sonar-scanner.properties

COPY ./sonar-scanner.properties /opt/sonar/conf/

# ENTRYPOINT

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
