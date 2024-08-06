FROM node:16

ARG NODE_ENV="production"

ENV GIT_REPO="https://github.com/crownstone-community/crownstone-cron.git"

# Tokens generated at install.
ENV AGGREGATION_TOKEN="" \
    SANITATION_TOKEN=

# MongoDB settings.
# You can fill in username and password here if you configured those.
# For example: mongodb://user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
ENV MONGO_CRON_DB_NAME="crownstone_cron" \
    MONGO_CRON_URL="mongodb://mongo-crownstone:27017/" \
    DATA_TABLE="users_v1" \
    USER_DB_URL="mongodb://mongo-crownstone:27017/users_v1" \
    DATA_TABLE="data_v1" \
    DATA_DB_URL="mongodb://mongo-crownstone:27017/data_v1" \
    FILES_TABLE="files_v1" \
    FILES_DB_URL="mongodb://mongo-crownstone:27017/files_v1" \
    MONGO_URL="mongodb://mongo-crownstone:27017/" \
    MONGO_CRON_URL=${MONGO_URL} \
    FILES_DB_URL2="${MONGO_URL}/files_v1"

# Other settings.
ENV HOST_NAME="localhost" \
    NODE_ENV=$NODE_ENV \
    DEADMANSSNITCH_API_KEY="" \
    SNITCH_URL="" \
    LOG_ENTRIES_TOKEN=""

# Dummy account to test if all servers work properly
ENV CROWNSTONE_USERNAME="" \
    CROWNSTONE_PASSWORD="" \
    VIRTUAL_CROWNSTONE_ID="" \
    WEBHOOK_API_KEY="" \
    HOOK_WAIT_TIME="10000"


# For Toon integration.
ENV TOON_CLIENT_ID="toon-id" \
    TOON_CLIENT_SECRET="toon-secret"

WORKDIR /crownstone-cron

RUN git clone "$GIT_REPO" . \
    && git fetch --tags \
	&& latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )" \
    && git checkout "$latest_tag" \
    \
    && yarn

# Install necessary software
RUN apt-get update && \
    apt-get -y install cron tini && \
    rm -rf /etc/cron.*/* && \
    tini --version

# Add crontab file
COPY crontab /etc/crontab

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "tini", "--", "/entrypoint.sh" ]
CMD ["cron","-f", "-l", "2"]