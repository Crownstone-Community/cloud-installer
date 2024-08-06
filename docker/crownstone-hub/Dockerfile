FROM node:14

ARG GIT_REPO="https://github.com/crownstone-community/hub.git"
# Ports at which this server is available.
# http port
ARG HTTP_PORT="3200"
ENV HTTP_PORT=$HTTP_PORT
# https port
ARG PORT="3201"
ENV PORT=$PORT

# You can fill in username and password here if you configured those.
# Supported formats:
# - mongodb:///domain:port
# - mongodb:///user:password@domain:port
ENV MONGO_URL="mongodb://mongo-crownstone:27017" \
    MONGO_DB="CrownstoneHub"

# By default, every USB device is tried to see if that's a crownstone dongle.
#
# Instead, a fixed device can be used, for example:
# CS_HUB_UART_PORT="/dev/ttyUSB0"
# CS_HUB_UART_PORT="/dev/serial/by-id/usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_014A641C-if00-port0"
#
# Or a search pattern can be used:
# CS_UART_SEARCH_BY_ID: "true"
# CS_UART_SEARCH_BY_ID_PATH: "/dev/serial/by-id"
# CS_UART_SEARCH_BY_ID_PATTERN: "(usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_.*|.*Crownstone_dongle.*)"

ENV CS_HUB_UART_PORT \
    CS_UART_SEARCH_BY_ID \
    CS_UART_SEARCH_BY_ID_PATH \
    CS_UART_SEARCH_BY_ID_PATTERN

# Where the config is written.
ENV CS_HUB_CONFIG_PATH=""

# Where the openssl-hub.conf is found. Defaults to ./config
ENV CS_HUB_SLL_CONFIG_PATH="./config"

# Where the https cert.pem and key.pem files are written to. Defaults to ./config/https
ENV CS_HUB_HTTPS_CERTIFICATE_PATH=""

# Log settings
ENV CS_ENABLE_FILE_LOGGING="false" \
    CS_FILE_LOGGING_DIRNAME="logs" \
    CS_FILE_LOGGING_LEVEL="info" \
    CS_CONSOLE_LOGGING_LEVEL="none" \
    DEBUG="" \
    DEBUG_HIDE_DATE="false" \
    DEBUG_LEVEL="INFO" \
    DEBUG_JSON="false"



# Cloud and addresses.
ENV CLOUD_V1_URL="http://crownstone-cloud:3000/api/" \
    CLOUD_V2_URL="http://crownstone-cloud-v2:3050/api/" \
    SSE_URL="http://crownstone-sse-server:8000/sse" \
    LOGIN_URL="http://crownstone-cloud:3000/api/users/login" \
    hubLoginBase="http://crownstone-cloud:3000/api/Hubs/"

WORKDIR /crownstone-hub

RUN git clone "$GIT_REPO" . \
    && git fetch --tags \
	&& latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )" \
    && git checkout "$latest_tag" \
    \
    && yarn

EXPOSE $HTTP_PORT
EXPOSE $PORT

COPY entrypoint-crownstone-hub.sh /crownstone-hub/

# ENTRYPOINT [ "node", "./execute.js" ]
ENTRYPOINT [ "/crownstone-hub/entrypoint-crownstone-hub.sh" ]
# ENTRYPOINT bash