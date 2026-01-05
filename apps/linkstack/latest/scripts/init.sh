install -d -m 777 ./data
CONTAINER_ID=$(docker create --pull always linkstackorg/linkstack:latest)
docker export $CONTAINER_ID | tar -x -C ./data htdocs --strip-components=1
docker rm $CONTAINER_ID