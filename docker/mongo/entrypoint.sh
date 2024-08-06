# Get the scripts path: the path where this file is located.
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DST=/docker-entrypoint-initdb.d/mongo-init.js

# # Insert MongoDB initial data.
# if [ ! -f "${THIS_DIR}/${MONGO_DB_ARGS_FILE_NAME}" ]; then
# 	echo "${PREFIX}Using template MongoDB arguments file."
# 	cp "${THIS_DIR}/${MONGO_DB_ARGS_TEMPLATE_FILE_NAME}" "${THIS_DIR}/${MONGO_DB_ARGS_FILE_NAME}"
# fi
# if [ ! -f "${THIS_DIR}/${MONGODB_INIT_SCRIPT_FILE_NAME}" ]; then
# 	echo "${PREFIX}Using template MongoDB script to insert initial data."
# 	cp "${THIS_DIR}/${MONGODB_INIT_SCRIPT_TEMPLATE_FILE_NAME}" "${THIS_DIR}/${MONGODB_INIT_SCRIPT_FILE_NAME}"
# fi
# echo "${PREFIX}MongoDB script file: ${THIS_DIR}/${MONGODB_INIT_SCRIPT_FILE_NAME}"
# echo "${PREFIX}Edit it to make sure all values are correct."

if [ ! -f "${MONGODB_INIT_SCRIPT_FILE_NAME}" ]; then MONGODB_INIT_SCRIPT_FILE_NAME=""; fi

echo "${PREFIX}Running MongoDB script to insert initial data."
# mongo $( head -n 1 "${THIS_DIR}/${MONGO_DB_ARGS_FILE_NAME}" ) "${THIS_DIR}/${MONGODB_INIT_SCRIPT_FILE_NAME}"
echo --port $PORT "${MONGODB_INIT_SCRIPT_FILE}"
mongo --port $PORT "${MONGODB_INIT_SCRIPT_FILE}"
echo "${PREFIX}Done running MongoDB script to insert initial data."