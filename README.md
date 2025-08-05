# ActiveMQ with Podman

This guide provides step-by-step instructions for running **Apache ActiveMQ** and a **Java Servlet (Tomcat) producer** inside Podman containers. It includes installation, container setup, message dispatching, and queue monitoring via the web console.

---

## REQUIRED DEPENDENCIES

Install Podman and ActiveMQ CLI tools:

```bash
sudo apt update
sudo apt install -y podman activemq
```

> **Note**: The `activemq` CLI is only used for local testing. The broker itself runs inside a container.

---

## AUTHENTICATE WITH DOCKER HUB

Log in to Docker Hub to allow pulling images:

```bash
podman login docker.io
```

---

## PULL ACTIVEMQ IMAGE

Download the prebuilt ActiveMQ image:

```bash
podman pull docker.io/rmohr/activemq
```

---

## BUILD CUSTOM IMAGE (OPTIONAL)

If you have a custom Dockerfile and configuration files:

```bash
podman build -t my-activemq-image ./activemq/
```

---

## RUN ACTIVEMQ IN A CONTAINER

Expose ActiveMQ’s ports:

```bash
podman run -d   -p 8161:8161 \   # Web Console
  -p 61616:61616 \ # JMS OpenWire
  localhost/my-activemq-image:latest
```

---

## ADDING A JAVA SERVLET PRODUCER (`servlet-activemq-dispatcher`)

This project includes a basic Java servlet that connects to the ActiveMQ broker and sends a message to a queue.

### Project Structure

```
servlet-activemq-dispatcher/
├── Dockerfile
├── WEB-INF/
│   └── web.xml
├── src/
│   └── MessageServlet.java
└── ...
```

### Build the Custom Tomcat Image

```bash
podman build -t my-tomcat-image ./servlet-activemq-dispatcher/
```

> Make sure the servlet is compiled and included in the `WEB-INF/classes` folder before building.

### Run Both in a Pod

To run ActiveMQ and Tomcat in a shared Pod (so they can talk via `localhost`):

```bash
# Create pod and expose external ports
podman pod create --name activemq-pod -p 8080:8080 -p 8161:8161 -p 61616:61616

# Run ActiveMQ container inside the pod
podman run -d --name activemq --pod activemq-pod localhost/my-activemq-image:latest

# Run the Tomcat servlet container inside the pod
podman run -d --name tomcat --pod activemq-pod localhost/my-tomcat-image:latest
```

### Access the Servlet

Once running, access the servlet via:

```
http://localhost:8080/send
```

Expected output:

```
Message sent successfully.
```

---

## SEND TEST MESSAGE TO QUEUE (Optional via CLI)

```bash
podman exec -it <container_id> /opt/activemq/bin/activemq producer \
  --destination queue://queue1 \
  --message "hello from container"
```

---

## ACCESS THE WEB CONSOLE

Browse to:

```
http://localhost:8161/
```

Default login:

- **Username**: `admin`
- **Password**: `admin`

---

## COMMON PODMAN COMMANDS

```bash
podman ps -a                  # List all containers
podman logs <container_id>   # View logs
podman exec -it <id> sh      # Open shell inside container
podman restart <id>          # Restart a container
podman image prune           # Remove unused images
podman system prune          # Remove unused resources
```

Copy ActiveMQ config:

```bash
podman cp <container_id>:/opt/activemq/conf/activemq.xml ./activemq.xml.bak
```

---

## OPTIONAL PROJECT STRUCTURE

```
.
├── activemq/
│   ├── Dockerfile
│   └── activemq.xml
│   └── queues.xml
├── servlet-activemq-dispatcher/
│   ├── Dockerfile
│   ├── WEB-INF/
│   └── src/
├── build.sh
└── README.md
```

---

## RESOURCES

- https://activemq.apache.org/
- https://podman.io/
- https://hub.docker.com/r/rmohr/activemq