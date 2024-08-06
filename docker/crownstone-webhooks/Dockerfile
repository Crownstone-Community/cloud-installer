FROM node:16

ENV GIT_REPO="https://github.com/crownstone-community/crownstone-webhooks.git"
ARG PORT="3100"

# Tokens generated at install.
ENV CROWNSTONE_CLOUD_SSE_TOKEN="" \
    CROWNSTONE_USER_ADMIN_KEY="" \
    DEBUG_TOKEN=

# Default settings.
ENV DEBUG="" \
    DEBUG_LEVEL="INFO"

# With host set to 0.0.0.0 the server is available from outside.
ENV HOST="0.0.0.0"

# Port at which this server is available.
ENV PORT=$PORT

# MongoDB settings
ENV MONGO_DB="crownstone_webhooks" \
    MONGO_URL="mongodb://mongo-crownstone:27017/"

# Number of calls allowed per day for each listener.
ENV DAILY_ALLOWANCE="5000"

# Used only for a log.
ENV BASE_URL="crownstone_webhooks"

# The endpoint for cloud v1, should match its settings.
ENV CROWNSTONE_CLOUD_SOCKET_ENDPOINT="http://crownstone-cloud:3000"

# The endpoint for cloud v2, should match its settings.
ENV CROWNSTONE_CLOUD_NEXT_SOCKET_ENDPOINT="http://crownstone-cloud-v2:3050"

WORKDIR /crownstone-webhooks

RUN git clone "$GIT_REPO" . \
    && git fetch --tags \
	&& latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )" \
    && git checkout "$latest_tag" \
    \
    && yarn \
    && npm run build

EXPOSE $PORT

ENTRYPOINT [ "node", "./execute.js" ]