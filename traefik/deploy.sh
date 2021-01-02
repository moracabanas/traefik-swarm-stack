#!/bin/sh
## SETUP
# Required cetwork check || create
docker network inspect traefik-public >/dev/null 2>&1 || \
    docker network create --driver=overlay traefik-public

# Add Manager node label constrain required on docker-compose.yml to limit Traefik to running on this node
NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

## DEPLOY

# Read .env and prevent console flood, then deploy stack
export $(cat .env) > /dev/null 2>&1; 
docker stack deploy -c docker-compose.yml ${1:-STACK_NAME}