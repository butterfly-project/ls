#!/bin/sh

DOCKER_STACK=$1
DOCKER_SERVICE="${DOCKER_STACK}_$2"
COMMAND=$3

while : ; do \
  COUNT_DOWN_SERVICES=$(docker stack services --format='{{.Replicas}}' cigaramobile | grep '0/' | wc -l); \
  COUNT_TASKS=$(docker service ps $DOCKER_SERVICE -q -f desired-state=running -f "name=$DOCKER_SERVICE.1" | wc -l); \
  DOCKER_TASK=$(docker service ps $DOCKER_SERVICE -q -f desired-state=running -f "name=$DOCKER_SERVICE.1"); \
  [ "$COUNT_DOWN_SERVICES" -ne "0" ] || [ "$COUNT_TASKS" -ne "1" ] || break; \
  echo "Wait stack available: '$DOCKER_STACK'"; \
  sleep 1; \
done

echo "DOCKER_STACK: ${DOCKER_STACK}"
echo "DOCKER_SERVICE: ${DOCKER_SERVICE}"
echo "COUNT_DOWN_SERVICES: ${COUNT_DOWN_SERVICES}"
echo "COUNT_TASKS: ${COUNT_TASKS}"
echo "DOCKER_TASK: ${DOCKER_TASK}"

DOCKER_CONTAINER=$(docker inspect -f '{{.Status.ContainerStatus.ContainerID}}' $DOCKER_TASK) 

docker exec $DOCKER_CONTAINER $COMMAND
