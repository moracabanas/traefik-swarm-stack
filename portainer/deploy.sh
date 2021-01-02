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

# Create a tag in this node, so that Portainer is always deployed to the same node and uses the existing volume:
NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add portainer.portainer-data=true $NODE_ID > /dev/null


echo -e "\n${LIGHTGREEN}Constraint labels updated${ENDCOLOR}"

## DEPLOY
# Read .env and prevent console flood, then deploy stack
export $(cat .env) > /dev/null 2>&1; 
docker stack deploy -c docker-compose.yml ${1:-$STACK_NAME} \
    && echo -e "\n${LIGHTGREEN} Deployment successful ${ENDCOLOR} \n"