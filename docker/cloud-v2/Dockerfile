FROM node:16

ARG GIT_REPO="https://github.com/crownstone-community/cloud-v2.git"

# Tokens generated at install.
ENV AGGREGATION_TOKEN="" \
    SANITATION_TOKEN="" \
    SSE_TOKEN=""

# Port at which this server is available.
ARG PORT="3050"
ENV PORT=$PORT

# MongoDB settings.
# You can fill in username and password here if you configured those.
# For example: mongodb://user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
# Mongo urls must start with mongodb:// otherwise a timeout will occur
ENV USER_DB_URL="mongodb://localhost:27017/users_v1" \
    DATA_DB_URL="mongodb://localhost:27017/data_v1" \
    FILES_DB_URL="mongodb://localhost:27017/files_v1"

# Other settings.
ENV EMAIL_VALIDATION_REQUIRED="false" \
    ALLOW_IMPORT="YES"

RUN git clone "$GIT_REPO" "/crownstone-cloud-v2" \
    && cd "/crownstone-cloud-v2" \
    && git fetch --tags \
	&& latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )" \
    && git checkout "$latest_tag" \
    \
    && yarn \
    && npm run build

WORKDIR /crownstone-cloud-v2

EXPOSE $PORT

ENTRYPOINT [ "/usr/local/bin/node", "execute.js" ]