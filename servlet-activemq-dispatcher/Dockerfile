FROM docker.io/library/tomcat:9.0-jdk17

COPY ./WEB-INF /usr/local/tomcat/webapps/ROOT/WEB-INF
COPY ./src/MessageServlet.java /tmp/MessageServlet.java

COPY ./WEB-INF/lib/log4j-api-2.17.2.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/
COPY ./WEB-INF/lib/log4j-core-2.17.2.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes && \
    javac -cp /usr/local/tomcat/lib/servlet-api.jar:/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/activemq-all-5.17.6.jar \
    /tmp/MessageServlet.java -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

EXPOSE 8080