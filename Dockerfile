FROM jenkins/jenkins:lts-jdk17
ARG PEM_KEY
USER root
RUN chown -R 1000:1000 /var/jenkins_home
RUN chmod -R 777 /var/jenkins_home
# Skip initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY ./plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY ./jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml
COPY ./${PEM_KEY}.pem /usr/share/jenkins/${PEM_KEY}.pem
ENV PRIVATEKEYPATH "/usr/share/jenkins/${PEM_KEY}.pem"
ENV REMOTEPATH "/home/ubuntu"
ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/jenkins.yaml
