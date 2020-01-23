FROM maven:latest

WORKDIR /root

COPY ./Java_Multistage_dockerfile .

RUN mvn clean install

RUN apt-get update -y && groupadd tomcat && useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

WORKDIR /tmp

RUN wget http://apachemirror.wuchna.com/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz

RUN  mkdir /opt/tomcat && tar -xvzf *.tar.gz -C /opt/tomcat --strip-components=1

WORKDIR /opt/tomcat

RUN chgrp -R tomcat /opt/tomcat && chmod -R g+r conf && chmod g+x conf &&  chown -R tomcat webapps/ work/ temp/ logs/ && chown -R tomcat webapps/ work/ temp/ logs/ 
RUN touch /etc/systemd/system/tomcat.service 


COPY ./tomcat-users.xml /conf/tomcat-users.xml

COPY ./tomcat.service /etc/systemd/system/tomcat.service

COPY ./context.xml /webapps/host-manager/META-INF/context.xml

RUN cp -r /root/target/java-tomcat-maven-example.war webapps
EXPOSE  8080 

ENTRYPOINT ["nohup /opt/tomcat/bin/startup.sh &"]
