#!/bin/bash
set -e

# Configurable names
POD_NAME="activemq-pod"
ACTIVEMQ_IMAGE="docker.io/rmohr/activemq:latest"
TOMCAT_IMAGE="docker.io/library/tomcat:9.0"
CUSTOM_ACTIVEMQ_IMAGE="localhost/my-activemq-image:latest"
CUSTOM_TOMCAT_IMAGE="localhost/my-tomcat-image:latest"

echo "Stopping and removing existing containers and pod..."
podman pod rm -f $POD_NAME || true
podman rm -f activemq tomcat || true

echo "Pulling latest ActiveMQ image if not present..."
if ! podman image exists $ACTIVEMQ_IMAGE; then
    podman pull $ACTIVEMQ_IMAGE
fi

echo "Pulling latest Tomcat image..."
podman pull $TOMCAT_IMAGE

echo "Building custom ActiveMQ image from ./activemq/..."
if [ -d "./activemq" ]; then
    podman build -t $CUSTOM_ACTIVEMQ_IMAGE ./activemq/
else
    echo "ERROR: Directory './activemq/' not found."
    exit 1
fi

echo "Building custom Tomcat image from ./servlet-activemq-dispatcher/..."
if [ -d "./servlet-activemq-dispatcher" ]; then
    podman build -t $CUSTOM_TOMCAT_IMAGE ./servlet-activemq-dispatcher/
else
    echo "ERROR: Directory './servlet-activemq-dispatcher/' not found."
    exit 1
fi

echo "Creating pod $POD_NAME and exposing ports..."
podman pod create --name $POD_NAME -p 8161:8161 -p 61616:61616 -p 8080:8080

echo "Running ActiveMQ container in pod..."
podman run -d --name activemq --pod $POD_NAME $CUSTOM_ACTIVEMQ_IMAGE

echo "Running Tomcat container in pod..."
podman run -d --name tomcat --pod $POD_NAME $CUSTOM_TOMCAT_IMAGE

echo "✅ Setup complete."
echo "🔌 ActiveMQ Console: http://localhost:8161"
echo "🌐 Servlet endpoint: http://localhost:8080/send"
