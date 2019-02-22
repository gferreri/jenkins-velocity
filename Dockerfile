FROM jenkins/jnlp-slave:3.19-1

ARG DOCKER_GID=497

USER root

ENV DOCKER_VERSION "18.03.1-ce"
ENV SONAR_SCANNER_VERSION="3.2.0.1227"
ENV DEPENDENCY_CHECK_VERSION="3.3.4"

RUN apt-get -y update && \
    # DOCKER
    apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common build-essential && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    apt-get -y update && \
    apt-get -y install docker-ce && \
    echo docker --version: $(docker --version) && \
    # NODE
    curl -sL https://deb.nodesource.com/setup_8.x | sudo bash - && \
    apt-get install nodejs && \
    npm install -g npm@5.7.1 && \
    echo node --version: $(node --version) && \
    echo npm --version: $(npm --version) && \
    # MONGODB
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 && \
    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list && \
    apt-get -y update && \
    apt-get install -y mongodb-org && \
    mkdir /data && \
    mkdir /data/db && \
    mkdir /data/db/log && \
    chown -R jenkins /data/db && \
    echo mongo --version: $(mongo --version) && \
    # YARN
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
    sudo apt-get update && sudo apt-get --no-install-recommends install yarn && \
    echo yarn --version: $(yarn --version) && \
    # HELM
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash && \
    echo helm version: $(helm version) && \
    # PIGZ
    apt-get install pigz -y && \
    # SONARQUBE
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip && \
    unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip && \
    mv sonar-scanner-$SONAR_SCANNER_VERSION-linux /opt/sonar && \
    export PATH=$PATH:/opt/sonar/bin && \
    chmod u+x -R /opt/sonar/bin && \
    rm /opt/sonar/conf/sonar-scanner.properties && \
    rm sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip && \
    # DEPENDENCY CHECKER
    wget http://dl.bintray.com/jeremy-long/owasp/dependency-check-$DEPENDENCY_CHECK_VERSION-release.zip && \
    unzip dependency-check-$DEPENDENCY_CHECK_VERSION-release.zip && \
    mv dependency-check /opt/dependency-check && \
    export PATH=$PATH:/opt/dependency-checker/bin/dependency-check.sh && \
    chmod u+x -R /opt/dependency-check/bin && \
    rm dependency-check-$DEPENDENCY_CHECK_VERSION-release.zip

# ENTRYPOINT
USER jenkins
COPY ./entrypoint.sh /
COPY ./sonar-scanner.properties /opt/sonar/conf/

ENTRYPOINT ["/entrypoint.sh"]
