#!/usr/bin/env bash

generateArtifacts() {
  printHeadline "Generating basic configs" "U1F913"

  printItalics "Generating crypto material for detran" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-detran.yaml" "peerOrganizations/detran.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for montadora" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-montadora.yaml" "peerOrganizations/montadora.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating genesis block for group orderers-group" "U1F3E0"
  genesisBlockCreate "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config" "Orderers-groupGenesis"

  # Create directory for chaincode packages to avoid permission errors on linux
  mkdir -p "$FABLO_NETWORK_ROOT/fabric-config/chaincode-packages"
}

startNetwork() {
  printHeadline "Starting network" "U1F680"
  (cd "$FABLO_NETWORK_ROOT"/fabric-docker && docker-compose up -d)
  sleep 4
}

generateChannelsArtifacts() {
  printHeadline "Generating config for 'car-channel'" "U1F913"
  createChannelTx "car-channel" "$FABLO_NETWORK_ROOT/fabric-config" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config/config"
  printHeadline "Generating config for 'person-channel'" "U1F913"
  createChannelTx "person-channel" "$FABLO_NETWORK_ROOT/fabric-config" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config/config"
}

installChannels() {
  printHeadline "Creating 'car-channel' on detran/peer0" "U1F63B"
  docker exec -i cli.detran.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; createChannelAndJoin 'car-channel' 'detranMSP' 'peer0.detran.car-lifes-cicle.com:7021' 'crypto/users/Admin@detran.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cicle.com:7030';"

  printItalics "Joining 'car-channel' on  detran/peer1" "U1F638"
  docker exec -i cli.detran.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'detranMSP' 'peer1.detran.car-lifes-cicle.com:7022' 'crypto/users/Admin@detran.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cicle.com:7030';"
  printItalics "Joining 'car-channel' on  montadora/peer0" "U1F638"
  docker exec -i cli.montadora.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'montadoraMSP' 'peer0.montadora.car-lifes-cicle.com:7041' 'crypto/users/Admin@montadora.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cicle.com:7030';"
  printItalics "Joining 'car-channel' on  montadora/peer1" "U1F638"
  docker exec -i cli.montadora.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'montadoraMSP' 'peer1.montadora.car-lifes-cicle.com:7042' 'crypto/users/Admin@montadora.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cicle.com:7030';"
  printHeadline "Creating 'person-channel' on detran/peer0" "U1F63B"
  docker exec -i cli.detran.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; createChannelAndJoin 'person-channel' 'detranMSP' 'peer0.detran.car-lifes-cicle.com:7021' 'crypto/users/Admin@detran.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cicle.com:7030';"

  printItalics "Joining 'person-channel' on  detran/peer1" "U1F638"
  docker exec -i cli.detran.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'detranMSP' 'peer1.detran.car-lifes-cicle.com:7022' 'crypto/users/Admin@detran.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cicle.com:7030';"
}

installChaincodes() {
  if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode")" ]; then
    local version="0.0.1"
    printHeadline "Packaging chaincode 'car'" "U1F60E"
    chaincodeBuild "car" "node" "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode" "12"
    chaincodePackage "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for detran" "U1F60E"
    chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car" "$version" ""
    chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022" "car" "$version" ""
    chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for montadora" "U1F60E"
    chaincodeInstall "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041" "car" "$version" ""
    chaincodeInstall "cli.montadora.car-lifes-cicle.com" "peer1.montadora.car-lifes-cicle.com:7042" "car" "$version" ""
    chaincodeApprove "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran'" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021,peer0.montadora.car-lifes-cicle.com:7041" "" ""
  else
    echo "Warning! Skipping chaincode 'car' installation. Chaincode directory is empty."
    echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
  fi
  if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode")" ]; then
    local version="0.0.1"
    printHeadline "Packaging chaincode 'person'" "U1F60E"
    chaincodeBuild "person" "node" "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode" "12"
    chaincodePackage "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person" "$version" "node" printHeadline "Installing 'person' for detran" "U1F60E"
    chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person" "$version" ""
    chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022" "person" "$version" ""
    chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran'" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021" "" ""
  else
    echo "Warning! Skipping chaincode 'person' installation. Chaincode directory is empty."
    echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode'"
  fi

}

installChaincode() {
  local chaincodeName="$1"
  if [ -z "$chaincodeName" ]; then
    echo "Error: chaincode name is not provided"
    exit 1
  fi

  local version="$2"
  if [ -z "$version" ]; then
    echo "Error: chaincode version is not provided"
    exit 1
  fi

  if [ "$chaincodeName" = "car" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode")" ]; then
      printHeadline "Packaging chaincode 'car'" "U1F60E"
      chaincodeBuild "car" "node" "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode" "12"
      chaincodePackage "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car" "$version" ""
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022" "car" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadora" "U1F60E"
      chaincodeInstall "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041" "car" "$version" ""
      chaincodeInstall "cli.montadora.car-lifes-cicle.com" "peer1.montadora.car-lifes-cicle.com:7042" "car" "$version" ""
      chaincodeApprove "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021,peer0.montadora.car-lifes-cicle.com:7041" "" ""

    else
      echo "Warning! Skipping chaincode 'car' install. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
    fi
  fi
  if [ "$chaincodeName" = "person" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode")" ]; then
      printHeadline "Packaging chaincode 'person'" "U1F60E"
      chaincodeBuild "person" "node" "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode" "12"
      chaincodePackage "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person" "$version" "node" printHeadline "Installing 'person' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person" "$version" ""
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022" "person" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021" "" ""

    else
      echo "Warning! Skipping chaincode 'person' install. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode'"
    fi
  fi
}

runDevModeChaincode() {
  local chaincodeName=$1
  if [ -z "$chaincodeName" ]; then
    echo "Error: chaincode name is not provided"
    exit 1
  fi

  if [ "$chaincodeName" = "car" ]; then
    local version="0.0.1"
    printHeadline "Approving 'car' for detran (dev mode)" "U1F60E"
    chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for montadora (dev mode)" "U1F60E"
    chaincodeApprove "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran' (dev mode)" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021,peer0.montadora.car-lifes-cicle.com:7041" "" ""

  fi
  if [ "$chaincodeName" = "person" ]; then
    local version="0.0.1"
    printHeadline "Approving 'person' for detran (dev mode)" "U1F60E"
    chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran' (dev mode)" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021" "" ""

  fi
}

upgradeChaincode() {
  local chaincodeName="$1"
  if [ -z "$chaincodeName" ]; then
    echo "Error: chaincode name is not provided"
    exit 1
  fi

  local version="$2"
  if [ -z "$version" ]; then
    echo "Error: chaincode version is not provided"
    exit 1
  fi

  if [ "$chaincodeName" = "car" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode")" ]; then
      printHeadline "Packaging chaincode 'car'" "U1F60E"
      chaincodeBuild "car" "node" "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode" "12"
      chaincodePackage "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car" "$version" ""
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022" "car" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadora" "U1F60E"
      chaincodeInstall "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041" "car" "$version" ""
      chaincodeInstall "cli.montadora.car-lifes-cicle.com" "peer1.montadora.car-lifes-cicle.com:7042" "car" "$version" ""
      chaincodeApprove "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021,peer0.montadora.car-lifes-cicle.com:7041" "" ""

    else
      echo "Warning! Skipping chaincode 'car' upgrade. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
    fi
  fi
  if [ "$chaincodeName" = "person" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode")" ]; then
      printHeadline "Packaging chaincode 'person'" "U1F60E"
      chaincodeBuild "person" "node" "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode" "12"
      chaincodePackage "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person" "$version" "node" printHeadline "Installing 'person' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person" "$version" ""
      chaincodeInstall "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022" "person" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030" "" "false" "" "peer0.detran.car-lifes-cicle.com:7021" "" ""

    else
      echo "Warning! Skipping chaincode 'person' upgrade. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode'"
    fi
  fi
}

notifyOrgsAboutChannels() {
  printHeadline "Creating new channel config blocks" "U1F537"
  createNewChannelUpdateTx "car-channel" "detranMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "montadoraMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "detranMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"

  printHeadline "Notyfing orgs about channels" "U1F4E2"
  notifyOrgAboutNewChannel "car-channel" "detranMSP" "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "montadoraMSP" "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "detranMSP" "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cicle.com:7030"

  printHeadline "Deleting new channel config blocks" "U1F52A"
  deleteNewChannelUpdateTx "car-channel" "detranMSP" "cli.detran.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "montadoraMSP" "cli.montadora.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "detranMSP" "cli.detran.car-lifes-cicle.com"
}

printStartSuccessInfo() {
  printHeadline "Done! Enjoy your fresh network" "U1F984"
}

stopNetwork() {
  printHeadline "Stopping network" "U1F68F"
  (cd "$FABLO_NETWORK_ROOT"/fabric-docker && docker-compose stop)
  sleep 4
}

networkDown() {
  printHeadline "Destroying network" "U1F916"
  (cd "$FABLO_NETWORK_ROOT"/fabric-docker && docker-compose down)

  printf "\nRemoving chaincode containers & images... \U1F5D1 \n"
  for container in $(docker ps -a | grep "dev-peer0.detran.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.detran.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.detran.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.detran.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.montadora.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.montadora.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.montadora.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.montadora.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.detran.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.detran.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.detran.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.detran.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done

  printf "\nRemoving generated configs... \U1F5D1 \n"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/crypto-config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/chaincode-packages"

  printHeadline "Done! Network was purged" "U1F5D1"
}
