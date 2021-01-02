#!/bin/sh
## SETUP
# Required network check || create
docker network inspect traefik-public >/dev/null 2>&1 || \
    docker network create --driver=overlay traefik-public

# Create a label in this node, so that the required databases used by Swarmpit is always deployed to the same node and uses the existing volume:
NODE_ID=$(docker info -f '{{.Swarm.NodeID}}')
docker node update --label-add traefik-public.traefik-public-certificates=true $NODE_ID

## DEPLOY

# Read .env and prevent console flood, then deploy stack
export $(cat .env) > /dev/null 2>&1; 
docker stack deploy -c docker-compose.yml ${1:-STACK_NAME}