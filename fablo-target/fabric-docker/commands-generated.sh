#!/usr/bin/env bash

generateArtifacts() {
  printHeadline "Generating basic configs" "U1F913"

  printItalics "Generating crypto material for Gov" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-gov.yaml" "peerOrganizations/gov.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for montadoraA" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-montadoraa.yaml" "peerOrganizations/montadora-a.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for mecanicaA" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-mecanicaa.yaml" "peerOrganizations/mecanica-a.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for seguradoraA" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-seguradoraa.yaml" "peerOrganizations/seguradora-a.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating genesis block for group group1" "U1F3E0"
  genesisBlockCreate "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config" "Group1Genesis"

  # Create directory for chaincode packages to avoid permission errors on linux
  mkdir -p "$FABLO_NETWORK_ROOT/fabric-config/chaincode-packages"
}

startNetwork() {
  printHeadline "Starting network" "U1F680"
  (cd "$FABLO_NETWORK_ROOT"/fabric-docker && docker-compose up -d)
  sleep 4
}

generateChannelsArtifacts() {
  printHeadline "Generating config for 'car-lifes-cicle-channel'" "U1F913"
  createChannelTx "car-lifes-cicle-channel" "$FABLO_NETWORK_ROOT/fabric-config" "CarLifesCicleChannel" "$FABLO_NETWORK_ROOT/fabric-config/config"
}

installChannels() {
  printHeadline "Creating 'car-lifes-cicle-channel' on Gov/peer0" "U1F63B"
  docker exec -i cli.gov.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; createChannelAndJoin 'car-lifes-cicle-channel' 'GovMSP' 'peer0.gov.car-lifes-cicle.com:7021' 'crypto/users/Admin@gov.car-lifes-cicle.com/msp' 'orderer0.group1.gov.car-lifes-cicle.com:7030';"

  printItalics "Joining 'car-lifes-cicle-channel' on  Gov/peer1" "U1F638"
  docker exec -i cli.gov.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-lifes-cicle-channel' 'GovMSP' 'peer1.gov.car-lifes-cicle.com:7022' 'crypto/users/Admin@gov.car-lifes-cicle.com/msp' 'orderer0.group1.gov.car-lifes-cicle.com:7030';"
  printItalics "Joining 'car-lifes-cicle-channel' on  montadoraA/peer0" "U1F638"
  docker exec -i cli.montadora-a.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-lifes-cicle-channel' 'montadoraAMSP' 'peer0.montadora-a.car-lifes-cicle.com:7041' 'crypto/users/Admin@montadora-a.car-lifes-cicle.com/msp' 'orderer0.group1.gov.car-lifes-cicle.com:7030';"
  printItalics "Joining 'car-lifes-cicle-channel' on  montadoraA/peer1" "U1F638"
  docker exec -i cli.montadora-a.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-lifes-cicle-channel' 'montadoraAMSP' 'peer1.montadora-a.car-lifes-cicle.com:7042' 'crypto/users/Admin@montadora-a.car-lifes-cicle.com/msp' 'orderer0.group1.gov.car-lifes-cicle.com:7030';"
  printItalics "Joining 'car-lifes-cicle-channel' on  mecanicaA/peer0" "U1F638"
  docker exec -i cli.mecanica-a.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-lifes-cicle-channel' 'mecanicaAMSP' 'peer0.mecanica-a.car-lifes-cicle.com:7061' 'crypto/users/Admin@mecanica-a.car-lifes-cicle.com/msp' 'orderer0.group1.gov.car-lifes-cicle.com:7030';"
  printItalics "Joining 'car-lifes-cicle-channel' on  mecanicaA/peer1" "U1F638"
  docker exec -i cli.mecanica-a.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-lifes-cicle-channel' 'mecanicaAMSP' 'peer1.mecanica-a.car-lifes-cicle.com:7062' 'crypto/users/Admin@mecanica-a.car-lifes-cicle.com/msp' 'orderer0.group1.gov.car-lifes-cicle.com:7030';"
}

installChaincodes() {
  if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript")" ]; then
    local version="0.0.1"
    printHeadline "Packaging chaincode 'alo'" "U1F60E"
    chaincodeBuild "alo" "node" "$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript" "12"
    chaincodePackage "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "alo" "$version" "node" printHeadline "Installing 'alo' for Gov" "U1F60E"
    chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "alo" "$version" ""
    chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022" "alo" "$version" ""
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Installing 'alo' for montadoraA" "U1F60E"
    chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "alo" "$version" ""
    chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042" "alo" "$version" ""
    chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Installing 'alo' for mecanicaA" "U1F60E"
    chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "alo" "$version" ""
    chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062" "alo" "$version" ""
    chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'alo' on channel 'car-lifes-cicle-channel' as 'Gov'" "U1F618"
    chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""
  else
    echo "Warning! Skipping chaincode 'alo' installation. Chaincode directory is empty."
    echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript'"
  fi
  if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode")" ]; then
    local version="0.0.1"
    printHeadline "Packaging chaincode 'car'" "U1F60E"
    chaincodeBuild "car" "node" "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode" "12"
    chaincodePackage "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for Gov" "U1F60E"
    chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car" "$version" ""
    chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022" "car" "$version" ""
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for montadoraA" "U1F60E"
    chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car" "$version" ""
    chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042" "car" "$version" ""
    chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for mecanicaA" "U1F60E"
    chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car" "$version" ""
    chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062" "car" "$version" ""
    chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'car' on channel 'car-lifes-cicle-channel' as 'Gov'" "U1F618"
    chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""
  else
    echo "Warning! Skipping chaincode 'car' installation. Chaincode directory is empty."
    echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
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

  if [ "$chaincodeName" = "alo" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript")" ]; then
      printHeadline "Packaging chaincode 'alo'" "U1F60E"
      chaincodeBuild "alo" "node" "$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript" "12"
      chaincodePackage "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "alo" "$version" "node" printHeadline "Installing 'alo' for Gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "alo" "$version" ""
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022" "alo" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'alo' for montadoraA" "U1F60E"
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "alo" "$version" ""
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042" "alo" "$version" ""
      chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'alo' for mecanicaA" "U1F60E"
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "alo" "$version" ""
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062" "alo" "$version" ""
      chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'alo' on channel 'car-lifes-cicle-channel' as 'Gov'" "U1F618"
      chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""

    else
      echo "Warning! Skipping chaincode 'alo' install. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript'"
    fi
  fi
  if [ "$chaincodeName" = "car" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode")" ]; then
      printHeadline "Packaging chaincode 'car'" "U1F60E"
      chaincodeBuild "car" "node" "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode" "12"
      chaincodePackage "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for Gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car" "$version" ""
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022" "car" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadoraA" "U1F60E"
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car" "$version" ""
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042" "car" "$version" ""
      chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for mecanicaA" "U1F60E"
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car" "$version" ""
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062" "car" "$version" ""
      chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'car' on channel 'car-lifes-cicle-channel' as 'Gov'" "U1F618"
      chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""

    else
      echo "Warning! Skipping chaincode 'car' install. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
    fi
  fi
}

runDevModeChaincode() {
  local chaincodeName=$1
  if [ -z "$chaincodeName" ]; then
    echo "Error: chaincode name is not provided"
    exit 1
  fi

  if [ "$chaincodeName" = "alo" ]; then
    local version="0.0.1"
    printHeadline "Approving 'alo' for Gov (dev mode)" "U1F60E"
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Approving 'alo' for montadoraA (dev mode)" "U1F60E"
    chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "alo" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Approving 'alo' for mecanicaA (dev mode)" "U1F60E"
    chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "alo" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'alo' on channel 'car-lifes-cicle-channel' as 'Gov' (dev mode)" "U1F618"
    chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""

  fi
  if [ "$chaincodeName" = "car" ]; then
    local version="0.0.1"
    printHeadline "Approving 'car' for Gov (dev mode)" "U1F60E"
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for montadoraA (dev mode)" "U1F60E"
    chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "car" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for mecanicaA (dev mode)" "U1F60E"
    chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "car" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'car' on channel 'car-lifes-cicle-channel' as 'Gov' (dev mode)" "U1F618"
    chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "0.0.1" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""

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

  if [ "$chaincodeName" = "alo" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript")" ]; then
      printHeadline "Packaging chaincode 'alo'" "U1F60E"
      chaincodeBuild "alo" "node" "$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript" "12"
      chaincodePackage "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "alo" "$version" "node" printHeadline "Installing 'alo' for Gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "alo" "$version" ""
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022" "alo" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'alo' for montadoraA" "U1F60E"
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "alo" "$version" ""
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042" "alo" "$version" ""
      chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'alo' for mecanicaA" "U1F60E"
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "alo" "$version" ""
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062" "alo" "$version" ""
      chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'alo' on channel 'car-lifes-cicle-channel' as 'Gov'" "U1F618"
      chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "alo" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""

    else
      echo "Warning! Skipping chaincode 'alo' upgrade. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/chaincode-typescript'"
    fi
  fi
  if [ "$chaincodeName" = "car" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode")" ]; then
      printHeadline "Packaging chaincode 'car'" "U1F60E"
      chaincodeBuild "car" "node" "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode" "12"
      chaincodePackage "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for Gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car" "$version" ""
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022" "car" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadoraA" "U1F60E"
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car" "$version" ""
      chaincodeInstall "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042" "car" "$version" ""
      chaincodeApprove "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for mecanicaA" "U1F60E"
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car" "$version" ""
      chaincodeInstall "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062" "car" "$version" ""
      chaincodeApprove "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'car' on channel 'car-lifes-cicle-channel' as 'Gov'" "U1F618"
      chaincodeCommit "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021" "car-lifes-cicle-channel" "car" "$version" "orderer0.group1.gov.car-lifes-cicle.com:7030" "" "false" "" "peer0.gov.car-lifes-cicle.com:7021,peer0.montadora-a.car-lifes-cicle.com:7041,peer0.mecanica-a.car-lifes-cicle.com:7061" "" ""

    else
      echo "Warning! Skipping chaincode 'car' upgrade. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
    fi
  fi
}

notifyOrgsAboutChannels() {
  printHeadline "Creating new channel config blocks" "U1F537"
  createNewChannelUpdateTx "car-lifes-cicle-channel" "GovMSP" "CarLifesCicleChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-lifes-cicle-channel" "montadoraAMSP" "CarLifesCicleChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-lifes-cicle-channel" "mecanicaAMSP" "CarLifesCicleChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"

  printHeadline "Notyfing orgs about channels" "U1F4E2"
  notifyOrgAboutNewChannel "car-lifes-cicle-channel" "GovMSP" "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com" "orderer0.group1.gov.car-lifes-cicle.com:7030"
  notifyOrgAboutNewChannel "car-lifes-cicle-channel" "montadoraAMSP" "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com" "orderer0.group1.gov.car-lifes-cicle.com:7030"
  notifyOrgAboutNewChannel "car-lifes-cicle-channel" "mecanicaAMSP" "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com" "orderer0.group1.gov.car-lifes-cicle.com:7030"

  printHeadline "Deleting new channel config blocks" "U1F52A"
  deleteNewChannelUpdateTx "car-lifes-cicle-channel" "GovMSP" "cli.gov.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-lifes-cicle-channel" "montadoraAMSP" "cli.montadora-a.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-lifes-cicle-channel" "mecanicaAMSP" "cli.mecanica-a.car-lifes-cicle.com"
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
  for container in $(docker ps -a | grep "dev-peer0.gov.car-lifes-cicle.com-alo" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.gov.car-lifes-cicle.com-alo*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.gov.car-lifes-cicle.com-alo" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.gov.car-lifes-cicle.com-alo*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.montadora-a.car-lifes-cicle.com-alo" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.montadora-a.car-lifes-cicle.com-alo*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.montadora-a.car-lifes-cicle.com-alo" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.montadora-a.car-lifes-cicle.com-alo*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.mecanica-a.car-lifes-cicle.com-alo" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.mecanica-a.car-lifes-cicle.com-alo*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.mecanica-a.car-lifes-cicle.com-alo" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.mecanica-a.car-lifes-cicle.com-alo*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.gov.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.gov.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.gov.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.gov.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.montadora-a.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.montadora-a.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.montadora-a.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.montadora-a.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.mecanica-a.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.mecanica-a.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer1.mecanica-a.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer1.mecanica-a.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done

  printf "\nRemoving generated configs... \U1F5D1 \n"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/crypto-config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/chaincode-packages"

  printHeadline "Done! Network was purged" "U1F5D1"
}
