ActiveMQ with Podman
====================

This guide provides step-by-step instructions for running Apache ActiveMQ inside a Podman container. It includes installation, container management, message sending, and configuration inspection.

REQUIRED DEPENDENCIES
---------------------

Install Podman and ActiveMQ CLI tools:

    sudo apt update
    sudo apt install -y podman activemq

Note: The `activemq` package is used to test sending messages locally via the CLI. The broker itself runs in the container.

AUTHENTICATE WITH DOCKER HUB
-----------------------------

Log in to Docker Hub so you can pull container images:

    podman login docker.io

PULL ACTIVEMQ IMAGE
-------------------

Pull a prebuilt ActiveMQ image from Docker Hub:

    podman pull docker.io/rmohr/activemq

BUILD CUSTOM IMAGE (OPTIONAL)
-----------------------------

If you have a custom Dockerfile (with modified config files):

    podman build -t my-activemq-image .

RUN ACTIVEMQ IN CONTAINER
-------------------------

Run ActiveMQ and expose required ports:

    podman run -d \
      -p 8161:8161 \   # Web Console
      -p 61616:61616 \ # JMS OpenWire
      localhost/my-activemq-image:latest

SEND TEST MESSAGE TO QUEUE
---------------------------

Use the container’s CLI tool to send a message:

    podman exec -it <container_id> /opt/activemq/bin/activemq producer \
      --destination queue://queue1 \
      --message "hello from container"

Replace <container_id> with the real container ID.

COMMON PODMAN COMMANDS
----------------------

Start a shell inside a container:

    podman exec -it <container_id> sh

List all containers:

    podman ps -a

View logs for a container:

    podman logs <container_id>

Restart a container:

    podman restart <container_id>

Remove unused images:

    podman image prune

Remove unused containers/networks/volumes:

    podman system prune

Copy ActiveMQ config out of a container:

    podman cp <container_id>:/opt/activemq/conf/activemq.xml ./activemq.xml.bak

Check if the Web UI port is active:

    podman exec -it <container_id> sh -c "netstat -tuln | grep 8161"

ACCESS THE WEB CONSOLE
-----------------------

Open a browser and go to:

    http://localhost:8161/

Default login:

    Username: admin
    Password: admin

This web console lets you browse queues, topics, consumers, and producers.

TIPS
----

- Queues such as `queue1` are auto-created when you publish to them.
- You can define queues in `queues.xml` and mount it into /opt/activemq/conf/queues.xml in your image or container.

OPTIONAL PROJECT STRUCTURE
--------------------------

If you're customizing configuration files:

    .
    ├── Dockerfile
    ├── activemq.xml
    ├── queues.xml
    └── README.txt

RESOURCES
---------

- https://activemq.apache.org/
- https://podman.io/
- https://hub.docker.com/r/rmohr/activemq