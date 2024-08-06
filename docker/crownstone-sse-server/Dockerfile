FROM node:16

ARG GIT_REPO="https://github.com/crownstone-community/crownstone-sse-server.git"
ARG PORT="8000"

# Tokens generated at install.
ENV CROWNSTONE_CLOUD_SSE_TOKEN="" \
    DEBUG_TOKEN=""

# Port at which this server is available.
ENV PORT=$PORT

# Used only for a log.
ENV BASE_URL="crownstone-sse-server"

# The endpoint for cloud v1, should match its settings.
ENV CROWNSTONE_CLOUD_SOCKET_ENDPOINT="http://crownstone-cloud:3000"

# The endpoint for cloud v2, should match its settings.
ENV CROWNSTONE_CLOUD_NEXT_SOCKET_ENDPOINT="http://crownstone-cloud-v2:3050"

WORKDIR /crownstone-sse-server

RUN git clone "$GIT_REPO" . \
    && git fetch --tags \
	&& latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )" \
    && git checkout "$latest_tag" \
    \
    && yarn \
    && npm run build

EXPOSE $PORT

ENTRYPOINT [ "node", "./dist/Server.js" ]