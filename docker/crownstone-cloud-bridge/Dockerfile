FROM node:14

ARG GIT_REPO="https://github.com/crownstone-community/crownstone-cloud-bridge.git"

# Cloud and addresses.
ENV CLOUD_V1_URL="http://crownstone-cloud:3000/api/" \
    CLOUD_V2_URL="http://crownstone-cloud-v2:3050/api/" \
    SSE_URL="http://crownstone-sse-server:8000/sse/" \
    WEBHOOK_URL="http://crownstone-webhook:3100/"

WORKDIR /crownstone-cloud-bridge

RUN git clone "$GIT_REPO" . \
    && git fetch --tags \
	&& latest_tag="$( git describe --tags $(git rev-list --tags --max-count=1) )" \
    && git checkout "$latest_tag" \
    \
    && yarn

ENTRYPOINT [ "node", "./execute.js" ]