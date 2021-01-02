#!/usr/bin/env bash

## COLORS
LIGHTBLUE="\e[94m"
RED="\e[31m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
LIGHTGREEN="\e[92m"

## SETUP
# Required network check || warning
docker network inspect traefik-public >/dev/null 2>&1 || \
    echo -e "${YELLOW}WARNING:${ENDCOLOR} ${RED}This setup requires Traefik and traefik-public network ${ENDCOLOR} \ncheck this docs: ${LIGHTBLUE}https://dockerswarm.rocks/traefik/ ${ENDCOLOR}"

# Create a label in this node, so that the CouchDB database used by Swarmpit is always deployed to the same node and uses the existing volume:
NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add swarmpit.db-data=true $NODE_ID > /dev/null
docker node update --label-add swarmpit.influx-data=true $NODE_ID > /dev/null  

echo -e "\n${LIGHTGREEN}Constraint labels updated${ENDCOLOR}"

## DEPLOY
# Read .env and prevent console flood, then deploy stack
export $(cat .env | grep -v -e "^#") >/dev/null; 
docker stack deploy -c docker-compose.rocks.yml ${1:-$STACK_NAME} \
    && echo -e "\n${LIGHTGREEN} Deployment successful ${ENDCOLOR} \n"