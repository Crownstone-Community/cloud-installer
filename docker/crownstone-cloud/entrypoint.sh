#!/bin/bash

# Exit when any command fails
set -e

# Check and generate tokens
[ "$SSE_TOKEN" = "" ] && export SSE_TOKEN="$( openssl rand -hex 128 )" && echo && echo "Generated SSE_TOKEN="$SSE_TOKEN
[ "$AGGREGATION_TOKEN" = "" ] && export AGGREGATION_TOKEN="$( openssl rand -hex 128 )" && echo && echo "Generated AGGREGATION_TOKEN="$AGGREGATION_TOKEN
[ "$SANITATION_TOKEN" = "" ] && export SANITATION_TOKEN="$( openssl rand -hex 128 )" && echo &&echo "Generated SANITATION_TOKEN="$SANITATION_TOKEN
[ "$SESSION_SECRET" = "" ] && export SESSION_SECRET="$( openssl rand -hex 128 )" && echo &&echo "Generated SESSION_SECRET="$SESSION_SECRET
[ "$CROWNSTONE_USER_ADMIN_KEY" = "" ] && export CROWNSTONE_USER_ADMIN_KEY="$( openssl rand -hex 128 )" && echo && echo "Generated CROWNSTONE_USER_ADMIN_KEY="$CROWNSTONE_USER_ADMIN_KEY
[ "$DEBUG_TOKEN" = "" ] && export DEBUG_TOKEN="nosecret"  && echo && echo "Generated DEBUG_TOKEN="$DEBUG_TOKEN

# Remove mongodb:// at the start, if present
export USER_DB_URL=`echo $USER_DB_URL | sed 's/mongodb:\/\///'`
export DATA_DB_URL=`echo $DATA_DB_URL | sed 's/mongodb:\/\///'`
export FILES_DB_URL=`echo $FILES_DB_URL | sed 's/mongodb:\/\///'`

# Apply environment variables into config files
src="/crownstone-cloud/server/datasources.production.js"
awk '/\"host\"/ {$2 = "\"'$MAIL_ADDRESS'\","} 1' $src > tmp && mv tmp $src
awk '/\"secure\"/ {$2 = "\"'$MAIL_SECURE'\","} 1' $src > tmp && mv tmp $src
awk '/\"port\"/ {$2 = "\"'$MAIL_PORT'\","} 1' $src > tmp && mv tmp $src
if [ "$MAIL_TLS_REJECTUNAUTHORIZED" = "false" ] || [ "$MAIL_TLS_REJECTUNAUTHORIZED" = "true" ]; then
    # check if tls is already set in config file
    if grep -Fq "tls" $src; then
        awk '/\"rejectUnauthorized\"/ {$4 = "'$MAIL_TLS_REJECTUNAUTHORIZED'" } 1' $src > tmp && mv tmp $src
    else
        # add tls if not present yet
        sed -i 's/\"SMTP\",/\"SMTP\",\n\"tls\": { \"rejectUnauthorized\": '$MAIL_TLS_REJECTUNAUTHORIZED' },/g' $src
    fi
fi

/usr/local/bin/node ./server/server.js