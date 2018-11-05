FROM jenkins/jnlp-slave:3.19-1

ARG DOCKER_GID=497

USER root

ENV DOCKER_VERSION "18.03.1-ce"
ENV SONAR_SCANNER_VERSION="3.2.0.1227"
ENV DEPENDENCY_CHECK_VERSION="3.3.4"

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
    && apt-get install -y mongodb-org \
    && mkdir /data \
    && mkdir /data/db \
    && mkdir /data/db/log

# SONARQUBE

RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip \
    && unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip

RUN mv sonar-scanner-$SONAR_SCANNER_VERSION-linux /opt/sonar \
    && export PATH=$PATH:/opt/sonar/bin \
    && chmod u+x -R /opt/sonar/bin \
    && rm /opt/sonar/conf/sonar-scanner.properties \
    && rm sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip

COPY ./sonar-scanner.properties /opt/sonar/conf/

# DEPENDENCY CHECKER

RUN wget http://dl.bintray.com/jeremy-long/owasp/dependency-check-$DEPENDENCY_CHECK_VERSION-release.zip \
    && unzip dependency-check-$DEPENDENCY_CHECK_VERSION-release.zip

RUN ls
RUN mv dependency-check /opt/dependency-check \
    && export PATH=$PATH:/opt/dependency-checker/bin/dependency-check.sh \
    && chmod u+x -R /opt/dependency-check/bin \
    && rm dependency-check-$DEPENDENCY_CHECK_VERSION-release.zip

# ENTRYPOINT

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
