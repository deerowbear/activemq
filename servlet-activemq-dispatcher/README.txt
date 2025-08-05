# Servlet + ActiveMQ + Java 17 Example (Tomcat 9)

## Prerequisites

- Podman or Docker
- Java 17-compatible ActiveMQ JAR (already referenced)

## Setup

1. Download ActiveMQ JAR (Java 8/11/17 compatible):

   https://repo1.maven.org/maven2/org/apache/activemq/activemq-all/5.15.15/activemq-all-5.15.15.jar

2. Place it in:
   `WEB-INF/lib/activemq-all-5.15.15.jar`

3. Build and run:

   ```bash
   ./build.sh
   ```

4. Visit: http://localhost:8080/send

   Then check: http://localhost:8161/admin/queues.jsp