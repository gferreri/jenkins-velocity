# jenkins-velocity

Jenkins jnlp agent with Docker CLI, Node 8.x, and MongoDb 3.6

The MongoDB instance is running unsecured at http://localhost on its default port.


## SonarQube Scanner

This base image installs `sonar-scanner` and `sonar-scanner-debug` as system binaries for use with sonarqube

It implements some default global configuration for the image, including some configuration for SonarJS.

**Default Example:**

```bash
sonar-scanner
```

Running this in your `Jenkinsfile` should suffice for most javascript projects. Note that it won't send an exit code if sonarqube's quality gate fails (i think?).

### Customize
Read [getting started with SonarJS](https://github.com/SonarSource/SonarJS/blob/master/docs/DOC.md#get-started) to set up additional and overriding configuration for your project, which can be contained in a `sonar-scanner.properties` file in the root of your own project, or passed as parameters in your project's `Jenkinsfile`.

**Customization Example**

Your `Jenkinsfile` could do this:

```bash
sonar-scanner 
    -Dsonar.host.url=http://localhost:9000
    -Dsonar.javascript.lcov.reportPaths=.nyc/lcov/lcov.info
    -Dsonar.branch.name=$GIT_BRANCH
```
