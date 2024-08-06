FROM node:12

ARG GIT_REPO="https://github.com/crownstone-community/crownstone-cloud.git"
ARG NODE_ENV="production"
ARG PORT="3000"

# Tokens generated at install.
ENV CROWNSTONE_CLOUD_SSE_TOKEN="" \
    AGGREGATION_TOKEN="" \
    SANITATION_TOKEN="" \
    SESSION_SECRET="" \
    DEBUG_TOKEN=""

ENV CROWNSTONE_USER_ADMIN_KEY="" \
    SSE_TOKEN=""

# Port at which this server is available.
ENV PORT=$PORT \
    BASE_URL=""

# Other settings.
ENV EMAIL_VERIFICATION_REQUIRED="false" \
    NODE_ENV=$NODE_ENV \
    NOTIFICATION_TYPE="release" \
    DEBUG="" \
    STRONGLOOP_CLUSTER="2"

# MongoDB settings.
# The URLs are prefixed with: mongodb://
# You can fill in username and password here if you configured those.
# For example: user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
ENV USER_TABLE="users_v1" \
    USER_DB_URL="localhost:27017/users_v1" \
    DATA_TABLE="data_v1" \
    DATA_DB_URL="localhost:27017/data_v1" \
    FILES_TABLE="files_v1" \
    FILES_DB_URL="localhost:27017/files_v1"

# Config variables for email validation, when enabled these should be filled in.
# https://github.com/nodemailer/nodemailer#setting-up
# Older Node versions do not fully support the certificate chain of the newest Let's Encrypt certificates. Either set tls.rejectUnauthorized to false to skip chain verification or upgrade your Node version
ENV MAIL_USER="my@email.address" \
    MAIL_PASSWORD="password" \
    MAIL_PROVIDER="gmail" \
    MAIL_ADDRESS="smtp.gmail.com" \
    MAIL_PORT="443" \
    MAIL_SECURE="true" \
    MAIL_TLS_REJECTUNAUTHORIZED="false"

# For Toon integration.
ENV TOON_CLIENT_ID="toon-id" \
    TOON_CLIENT_SECRET="toon-secret"

RUN git clone "$GIT_REPO" "/crownstone-cloud" \
    && cd "/crownstone-cloud" \
    && git fetch --tags \
	&& latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )" \
    && git checkout "$latest_tag" \
    \
    && yarn

WORKDIR /crownstone-cloud

EXPOSE $PORT

COPY entrypoint.sh /crownstone-cloud/

ENTRYPOINT [ "bash", "./entrypoint.sh" ]