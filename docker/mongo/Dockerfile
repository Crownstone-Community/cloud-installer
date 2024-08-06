FROM ubuntu:focal

ARG MONGO_VERSION="4.4.15"
ARG PORT="27017"
ENV PORT=$PORT

# Add mongodb package server
RUN apt update -y \
 && apt-get install -y gnupg wget lsb-release \
 && wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
 && CODENAME="$( lsb_release -a | grep Codename: | awk '{print $NF}' )" \
 && if [ "$CODENNAME" = "" ]; then CODENAME="focal"; fi \
 && echo "${PREFIX}Using packages for Ubuntu $CODENAME" \
 && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu ${CODENAME}/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# Install mongodb
# Use version 4.4.15, because https://stackoverflow.com/questions/68937131/illegal-instruction-core-dumped-mongodb-ubuntu-20-04-lts
RUN apt-get update -y \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y mongodb-org=$MONGO_VERSION mongodb-org-server=$MONGO_VERSION mongodb-org-shell=$MONGO_VERSION mongodb-org-mongos=$MONGO_VERSION mongodb-org-tools=$MONGO_VERSION

EXPOSE $PORT

VOLUME /data/db

ENTRYPOINT mongod --bind_ip_all --port $PORT