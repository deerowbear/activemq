# Use the official ActiveMQ image as the base.
# The original image is maintained by the community, providing a stable foundation.
FROM docker.io/rmohr/activemq

# Expose the necessary ports for the web console (8161) and STOMP connections (61616).
# Exposing ports at build time documents the image's purpose, but you still need
# to map them at runtime with `podman run -p`.
EXPOSE 8161
EXPOSE 61616

# Copy your custom configuration file into the image.
# This assumes that the `activemq.xml` file is located in the same directory as this Dockerfile.
# This approach ensures your configuration is part of the image, making it portable.
COPY activemq.xml /opt/activemq/conf/activemq.xml
COPY queues.xml /opt/activemq/conf/queues.xml
