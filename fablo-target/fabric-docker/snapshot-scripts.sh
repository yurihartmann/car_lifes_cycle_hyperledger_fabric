#!/usr/bin/env bash

__getOrdererAndPeerNodes() {
  echo "
      orderer0.group1.gov.car-lifes-cicle.com
      orderer1.group1.gov.car-lifes-cicle.com
      orderer2.group1.gov.car-lifes-cicle.com
      peer0.gov.car-lifes-cicle.com
      peer1.gov.car-lifes-cicle.com
      peer0.montadora-a.car-lifes-cicle.com
      peer1.montadora-a.car-lifes-cicle.com
      peer0.mecanica-a.car-lifes-cicle.com
      peer1.mecanica-a.car-lifes-cicle.com
      peer0.seguradora-a.car-lifes-cicle.com
      peer1.seguradora-a.car-lifes-cicle.com
  "
}

__getCASQLiteNodes() {
  echo "
      ca.gov.car-lifes-cicle.com
      ca.montadora-a.car-lifes-cicle.com
      ca.mecanica-a.car-lifes-cicle.com
      ca.seguradora-a.car-lifes-cicle.com
  "
}

__getCAPostgresNodes() {
  echo "
  "
}

__createSnapshot() {
  cd "$FABLO_NETWORK_ROOT/.."
  backup_dir="${1:-"snapshot-$(date -u +"%Y%m%d%H%M%S")"}"

  if [ -d "$backup_dir" ] && [ "$(ls -A "$backup_dir")" ]; then
    echo "Error: Directory '$backup_dir' already exists and is not empty!"
    exit 1
  fi

  mkdir -p "$backup_dir"
  cp -R ./fablo-target "$backup_dir/"

  for node in $(__getCASQLiteNodes); do
    echo "Saving state of $node..."
    mkdir -p "$backup_dir/$node"
    docker cp "$node:/etc/hyperledger/fabric-ca-server/fabric-ca-server.db" "$backup_dir/$node/fabric-ca-server.db"
  done

  for node in $(__getCAPostgresNodes); do
    echo "Saving state of $node..."
    mkdir -p "$backup_dir/$node/pg-data"
    docker exec "$node" pg_dump -c --if-exists -U postgres fabriccaserver >"$backup_dir/$node/fabriccaserver.sql"
  done

  for node in $(__getOrdererAndPeerNodes); do
    echo "Saving state of $node..."
    docker cp "$node:/var/hyperledger/production/" "$backup_dir/$node/"
  done
}

__cloneSnapshot() {
  cd "$FABLO_NETWORK_ROOT/.."
  target_dir="$1"
  hook_cmd="$2"

  if [ -d "$target_dir/fablo-target" ]; then
    echo "Error: Directory '$target_dir/fablo-target' already exists! Execute 'fablo prune' to remove the current network."
    exit 1
  fi

  cp -R ./fablo-target "$target_dir/fablo-target"

  if [ -n "$hook_cmd" ]; then
    echo "Executing pre-restore hook: '$hook_cmd'"
    (cd "$target_dir" && eval "$hook_cmd")
  fi

  (cd "$target_dir/fablo-target/fabric-docker" && docker-compose up --no-start)

  for node in $(__getCASQLiteNodes); do
    echo "Restoring $node..."
    if [ ! -d "$node" ]; then
      echo "Warning: Cannot restore '$node', directory does not exist!"
    else
      docker cp "./$node/fabric-ca-server.db" "$node:/etc/hyperledger/fabric-ca-server/fabric-ca-server.db"
    fi
  done

  for node in $(__getCAPostgresNodes); do
    echo "Restoring $node..."
    if [ ! -d "$node" ]; then
      echo "Warning: Cannot restore '$node', directory does not exist!"
    else
      docker cp "./$node/fabriccaserver.sql" "$node:/docker-entrypoint-initdb.d/fabriccaserver.sql"
    fi
  done

  for node in $(__getOrdererAndPeerNodes); do
    echo "Restoring $node..."
    if [ ! -d "$node" ]; then
      echo "Warning: Cannot restore '$node', directory does not exist!"
    else
      docker cp "./$node/" "$node:/var/hyperledger/production/"
    fi
  done
}

createSnapshot() {
  (set -eu && __createSnapshot "$1")
}

cloneSnapshot() {
  (set -eu && __cloneSnapshot "$1" "$2")
}
