#!/usr/bin/env bash

generateArtifacts() {
  printHeadline "Generating basic configs" "U1F913"

  printItalics "Generating crypto material for detran" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-detran.yaml" "peerOrganizations/detran.car-lifes-cycle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for gov" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-gov.yaml" "peerOrganizations/gov.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for montadoraC" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-montadorac.yaml" "peerOrganizations/montadora-c.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for montadoraD" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-montadorad.yaml" "peerOrganizations/montadora-d.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for concessionariF" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-concessionarif.yaml" "peerOrganizations/concessionaria-f.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for concessionariG" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-concessionarig.yaml" "peerOrganizations/concessionaria-g.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for mecanicaK" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-mecanicak.yaml" "peerOrganizations/mecanica-k.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for mecanicaL" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-mecanical.yaml" "peerOrganizations/mecanica-l.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

  printItalics "Generating crypto material for financiadoraR" "U1F512"
  certsGenerate "$FABLO_NETWORK_ROOT/fabric-config" "crypto-config-financiadorar.yaml" "peerOrganizations/financiadora-r.car-lifes-cicle.com" "$FABLO_NETWORK_ROOT/fabric-config/crypto-config/"

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
  docker exec -i cli.detran.car-lifes-cycle.com bash -c "source scripts/channel_fns.sh; createChannelAndJoin 'car-channel' 'detranMSP' 'peer0.detran.car-lifes-cycle.com:7021' 'crypto/users/Admin@detran.car-lifes-cycle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"

  printItalics "Joining 'car-channel' on  gov/peer0" "U1F638"
  docker exec -i cli.gov.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'govMSP' 'peer0.gov.car-lifes-cicle.com:7041' 'crypto/users/Admin@gov.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'car-channel' on  montadoraC/peer0" "U1F638"
  docker exec -i cli.montadora-c.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'montadoraCMSP' 'peer0.montadora-c.car-lifes-cicle.com:7061' 'crypto/users/Admin@montadora-c.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'car-channel' on  montadoraD/peer0" "U1F638"
  docker exec -i cli.montadora-d.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'montadoraDMSP' 'peer0.montadora-d.car-lifes-cicle.com:7081' 'crypto/users/Admin@montadora-d.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'car-channel' on  concessionariF/peer0" "U1F638"
  docker exec -i cli.concessionaria-f.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'concessionariFMSP' 'peer0.concessionaria-f.car-lifes-cicle.com:7101' 'crypto/users/Admin@concessionaria-f.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'car-channel' on  concessionariG/peer0" "U1F638"
  docker exec -i cli.concessionaria-g.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'concessionariGMSP' 'peer0.concessionaria-g.car-lifes-cicle.com:7121' 'crypto/users/Admin@concessionaria-g.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'car-channel' on  mecanicaK/peer0" "U1F638"
  docker exec -i cli.mecanica-k.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'mecanicaKMSP' 'peer0.mecanica-k.car-lifes-cicle.com:7141' 'crypto/users/Admin@mecanica-k.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'car-channel' on  mecanicaL/peer0" "U1F638"
  docker exec -i cli.mecanica-l.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'mecanicaLMSP' 'peer0.mecanica-l.car-lifes-cicle.com:7161' 'crypto/users/Admin@mecanica-l.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'car-channel' on  financiadoraR/peer0" "U1F638"
  docker exec -i cli.financiadora-r.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'car-channel' 'financiadoraRMSP' 'peer0.financiadora-r.car-lifes-cicle.com:7181' 'crypto/users/Admin@financiadora-r.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printHeadline "Creating 'person-channel' on detran/peer0" "U1F63B"
  docker exec -i cli.detran.car-lifes-cycle.com bash -c "source scripts/channel_fns.sh; createChannelAndJoin 'person-channel' 'detranMSP' 'peer0.detran.car-lifes-cycle.com:7021' 'crypto/users/Admin@detran.car-lifes-cycle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"

  printItalics "Joining 'person-channel' on  gov/peer0" "U1F638"
  docker exec -i cli.gov.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'govMSP' 'peer0.gov.car-lifes-cicle.com:7041' 'crypto/users/Admin@gov.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'person-channel' on  montadoraC/peer0" "U1F638"
  docker exec -i cli.montadora-c.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'montadoraCMSP' 'peer0.montadora-c.car-lifes-cicle.com:7061' 'crypto/users/Admin@montadora-c.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'person-channel' on  montadoraD/peer0" "U1F638"
  docker exec -i cli.montadora-d.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'montadoraDMSP' 'peer0.montadora-d.car-lifes-cicle.com:7081' 'crypto/users/Admin@montadora-d.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'person-channel' on  concessionariF/peer0" "U1F638"
  docker exec -i cli.concessionaria-f.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'concessionariFMSP' 'peer0.concessionaria-f.car-lifes-cicle.com:7101' 'crypto/users/Admin@concessionaria-f.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'person-channel' on  concessionariG/peer0" "U1F638"
  docker exec -i cli.concessionaria-g.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'concessionariGMSP' 'peer0.concessionaria-g.car-lifes-cicle.com:7121' 'crypto/users/Admin@concessionaria-g.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'person-channel' on  mecanicaK/peer0" "U1F638"
  docker exec -i cli.mecanica-k.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'mecanicaKMSP' 'peer0.mecanica-k.car-lifes-cicle.com:7141' 'crypto/users/Admin@mecanica-k.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'person-channel' on  mecanicaL/peer0" "U1F638"
  docker exec -i cli.mecanica-l.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'mecanicaLMSP' 'peer0.mecanica-l.car-lifes-cicle.com:7161' 'crypto/users/Admin@mecanica-l.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
  printItalics "Joining 'person-channel' on  financiadoraR/peer0" "U1F638"
  docker exec -i cli.financiadora-r.car-lifes-cicle.com bash -c "source scripts/channel_fns.sh; fetchChannelAndJoin 'person-channel' 'financiadoraRMSP' 'peer0.financiadora-r.car-lifes-cicle.com:7181' 'crypto/users/Admin@financiadora-r.car-lifes-cicle.com/msp' 'orderer0.orderers-group.detran.car-lifes-cycle.com:7030';"
}

installChaincodes() {
  if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode")" ]; then
    local version="0.0.1"
    printHeadline "Packaging chaincode 'car'" "U1F60E"
    chaincodeBuild "car" "node" "$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode" "12"
    chaincodePackage "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for detran" "U1F60E"
    chaincodeInstall "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car" "$version" ""
    chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for gov" "U1F60E"
    chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "car" "$version" ""
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for montadoraC" "U1F60E"
    chaincodeInstall "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "car" "$version" ""
    chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for montadoraD" "U1F60E"
    chaincodeInstall "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "car" "$version" ""
    chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for concessionariF" "U1F60E"
    chaincodeInstall "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "car" "$version" ""
    chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for concessionariG" "U1F60E"
    chaincodeInstall "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "car" "$version" ""
    chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for mecanicaK" "U1F60E"
    chaincodeInstall "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "car" "$version" ""
    chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for mecanicaL" "U1F60E"
    chaincodeInstall "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "car" "$version" ""
    chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'car' for financiadoraR" "U1F60E"
    chaincodeInstall "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "car" "$version" ""
    chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran'" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""
  else
    echo "Warning! Skipping chaincode 'car' installation. Chaincode directory is empty."
    echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
  fi
  if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode")" ]; then
    local version="0.0.1"
    printHeadline "Packaging chaincode 'person'" "U1F60E"
    chaincodeBuild "person" "node" "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode" "12"
    chaincodePackage "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person" "$version" "node" printHeadline "Installing 'person' for detran" "U1F60E"
    chaincodeInstall "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person" "$version" ""
    chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for gov" "U1F60E"
    chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "person" "$version" ""
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for montadoraC" "U1F60E"
    chaincodeInstall "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "person" "$version" ""
    chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for montadoraD" "U1F60E"
    chaincodeInstall "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "person" "$version" ""
    chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for concessionariF" "U1F60E"
    chaincodeInstall "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "person" "$version" ""
    chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for concessionariG" "U1F60E"
    chaincodeInstall "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "person" "$version" ""
    chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for mecanicaK" "U1F60E"
    chaincodeInstall "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "person" "$version" ""
    chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for mecanicaL" "U1F60E"
    chaincodeInstall "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "person" "$version" ""
    chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Installing 'person' for financiadoraR" "U1F60E"
    chaincodeInstall "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "person" "$version" ""
    chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran'" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""
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
      chaincodePackage "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "car" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadoraC" "U1F60E"
      chaincodeInstall "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "car" "$version" ""
      chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadoraD" "U1F60E"
      chaincodeInstall "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "car" "$version" ""
      chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for concessionariF" "U1F60E"
      chaincodeInstall "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "car" "$version" ""
      chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for concessionariG" "U1F60E"
      chaincodeInstall "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "car" "$version" ""
      chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for mecanicaK" "U1F60E"
      chaincodeInstall "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "car" "$version" ""
      chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for mecanicaL" "U1F60E"
      chaincodeInstall "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "car" "$version" ""
      chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for financiadoraR" "U1F60E"
      chaincodeInstall "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "car" "$version" ""
      chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""

    else
      echo "Warning! Skipping chaincode 'car' install. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
    fi
  fi
  if [ "$chaincodeName" = "person" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode")" ]; then
      printHeadline "Packaging chaincode 'person'" "U1F60E"
      chaincodeBuild "person" "node" "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode" "12"
      chaincodePackage "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person" "$version" "node" printHeadline "Installing 'person' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "person" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for montadoraC" "U1F60E"
      chaincodeInstall "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "person" "$version" ""
      chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for montadoraD" "U1F60E"
      chaincodeInstall "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "person" "$version" ""
      chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for concessionariF" "U1F60E"
      chaincodeInstall "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "person" "$version" ""
      chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for concessionariG" "U1F60E"
      chaincodeInstall "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "person" "$version" ""
      chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for mecanicaK" "U1F60E"
      chaincodeInstall "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "person" "$version" ""
      chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for mecanicaL" "U1F60E"
      chaincodeInstall "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "person" "$version" ""
      chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for financiadoraR" "U1F60E"
      chaincodeInstall "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "person" "$version" ""
      chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""

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
    chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for gov (dev mode)" "U1F60E"
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for montadoraC (dev mode)" "U1F60E"
    chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for montadoraD (dev mode)" "U1F60E"
    chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for concessionariF (dev mode)" "U1F60E"
    chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for concessionariG (dev mode)" "U1F60E"
    chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for mecanicaK (dev mode)" "U1F60E"
    chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for mecanicaL (dev mode)" "U1F60E"
    chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'car' for financiadoraR (dev mode)" "U1F60E"
    chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran' (dev mode)" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""

  fi
  if [ "$chaincodeName" = "person" ]; then
    local version="0.0.1"
    printHeadline "Approving 'person' for detran (dev mode)" "U1F60E"
    chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for gov (dev mode)" "U1F60E"
    chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for montadoraC (dev mode)" "U1F60E"
    chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for montadoraD (dev mode)" "U1F60E"
    chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for concessionariF (dev mode)" "U1F60E"
    chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for concessionariG (dev mode)" "U1F60E"
    chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for mecanicaK (dev mode)" "U1F60E"
    chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for mecanicaL (dev mode)" "U1F60E"
    chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printHeadline "Approving 'person' for financiadoraR (dev mode)" "U1F60E"
    chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
    printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran' (dev mode)" "U1F618"
    chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "0.0.1" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""

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
      chaincodePackage "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car" "$version" "node" printHeadline "Installing 'car' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "car" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadoraC" "U1F60E"
      chaincodeInstall "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "car" "$version" ""
      chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for montadoraD" "U1F60E"
      chaincodeInstall "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "car" "$version" ""
      chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for concessionariF" "U1F60E"
      chaincodeInstall "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "car" "$version" ""
      chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for concessionariG" "U1F60E"
      chaincodeInstall "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "car" "$version" ""
      chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for mecanicaK" "U1F60E"
      chaincodeInstall "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "car" "$version" ""
      chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for mecanicaL" "U1F60E"
      chaincodeInstall "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "car" "$version" ""
      chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'car' for financiadoraR" "U1F60E"
      chaincodeInstall "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "car" "$version" ""
      chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'car' on channel 'car-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "car-channel" "car" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""

    else
      echo "Warning! Skipping chaincode 'car' upgrade. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/car-chaincode'"
    fi
  fi
  if [ "$chaincodeName" = "person" ]; then
    if [ -n "$(ls "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode")" ]; then
      printHeadline "Packaging chaincode 'person'" "U1F60E"
      chaincodeBuild "person" "node" "$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode" "12"
      chaincodePackage "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person" "$version" "node" printHeadline "Installing 'person' for detran" "U1F60E"
      chaincodeInstall "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person" "$version" ""
      chaincodeApprove "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for gov" "U1F60E"
      chaincodeInstall "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "person" "$version" ""
      chaincodeApprove "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for montadoraC" "U1F60E"
      chaincodeInstall "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "person" "$version" ""
      chaincodeApprove "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for montadoraD" "U1F60E"
      chaincodeInstall "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "person" "$version" ""
      chaincodeApprove "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for concessionariF" "U1F60E"
      chaincodeInstall "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "person" "$version" ""
      chaincodeApprove "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for concessionariG" "U1F60E"
      chaincodeInstall "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "person" "$version" ""
      chaincodeApprove "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for mecanicaK" "U1F60E"
      chaincodeInstall "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "person" "$version" ""
      chaincodeApprove "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for mecanicaL" "U1F60E"
      chaincodeInstall "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "person" "$version" ""
      chaincodeApprove "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printHeadline "Installing 'person' for financiadoraR" "U1F60E"
      chaincodeInstall "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "person" "$version" ""
      chaincodeApprove "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" ""
      printItalics "Committing chaincode 'person' on channel 'person-channel' as 'detran'" "U1F618"
      chaincodeCommit "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021" "person-channel" "person" "$version" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030" "" "false" "" "peer0.detran.car-lifes-cycle.com:7021,peer0.gov.car-lifes-cicle.com:7041,peer0.montadora-c.car-lifes-cicle.com:7061,peer0.montadora-d.car-lifes-cicle.com:7081,peer0.concessionaria-f.car-lifes-cicle.com:7101,peer0.concessionaria-g.car-lifes-cicle.com:7121,peer0.mecanica-k.car-lifes-cicle.com:7141,peer0.mecanica-l.car-lifes-cicle.com:7161,peer0.financiadora-r.car-lifes-cicle.com:7181" "" ""

    else
      echo "Warning! Skipping chaincode 'person' upgrade. Chaincode directory is empty."
      echo "Looked in dir: '$CHAINCODES_BASE_DIR/./chaincodes/person-chaincode'"
    fi
  fi
}

notifyOrgsAboutChannels() {
  printHeadline "Creating new channel config blocks" "U1F537"
  createNewChannelUpdateTx "car-channel" "detranMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "govMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "montadoraCMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "montadoraDMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "concessionariFMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "concessionariGMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "mecanicaKMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "mecanicaLMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "car-channel" "financiadoraRMSP" "CarChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "detranMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "govMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "montadoraCMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "montadoraDMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "concessionariFMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "concessionariGMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "mecanicaKMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "mecanicaLMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"
  createNewChannelUpdateTx "person-channel" "financiadoraRMSP" "PersonChannel" "$FABLO_NETWORK_ROOT/fabric-config" "$FABLO_NETWORK_ROOT/fabric-config/config"

  printHeadline "Notyfing orgs about channels" "U1F4E2"
  notifyOrgAboutNewChannel "car-channel" "detranMSP" "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "govMSP" "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "montadoraCMSP" "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "montadoraDMSP" "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "concessionariFMSP" "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "concessionariGMSP" "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "mecanicaKMSP" "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "mecanicaLMSP" "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "car-channel" "financiadoraRMSP" "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "detranMSP" "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "govMSP" "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "montadoraCMSP" "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "montadoraDMSP" "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "concessionariFMSP" "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "concessionariGMSP" "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "mecanicaKMSP" "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "mecanicaLMSP" "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"
  notifyOrgAboutNewChannel "person-channel" "financiadoraRMSP" "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com" "orderer0.orderers-group.detran.car-lifes-cycle.com:7030"

  printHeadline "Deleting new channel config blocks" "U1F52A"
  deleteNewChannelUpdateTx "car-channel" "detranMSP" "cli.detran.car-lifes-cycle.com"
  deleteNewChannelUpdateTx "car-channel" "govMSP" "cli.gov.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "montadoraCMSP" "cli.montadora-c.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "montadoraDMSP" "cli.montadora-d.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "concessionariFMSP" "cli.concessionaria-f.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "concessionariGMSP" "cli.concessionaria-g.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "mecanicaKMSP" "cli.mecanica-k.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "mecanicaLMSP" "cli.mecanica-l.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "car-channel" "financiadoraRMSP" "cli.financiadora-r.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "detranMSP" "cli.detran.car-lifes-cycle.com"
  deleteNewChannelUpdateTx "person-channel" "govMSP" "cli.gov.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "montadoraCMSP" "cli.montadora-c.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "montadoraDMSP" "cli.montadora-d.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "concessionariFMSP" "cli.concessionaria-f.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "concessionariGMSP" "cli.concessionaria-g.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "mecanicaKMSP" "cli.mecanica-k.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "mecanicaLMSP" "cli.mecanica-l.car-lifes-cicle.com"
  deleteNewChannelUpdateTx "person-channel" "financiadoraRMSP" "cli.financiadora-r.car-lifes-cicle.com"
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
  for container in $(docker ps -a | grep "dev-peer0.detran.car-lifes-cycle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.detran.car-lifes-cycle.com-car*" -q); do
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
  for container in $(docker ps -a | grep "dev-peer0.montadora-c.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.montadora-c.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.montadora-d.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.montadora-d.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.concessionaria-f.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.concessionaria-f.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.concessionaria-g.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.concessionaria-g.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.mecanica-k.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.mecanica-k.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.mecanica-l.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.mecanica-l.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.financiadora-r.car-lifes-cicle.com-car" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.financiadora-r.car-lifes-cicle.com-car*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.detran.car-lifes-cycle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.detran.car-lifes-cycle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.gov.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.gov.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.montadora-c.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.montadora-c.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.montadora-d.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.montadora-d.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.concessionaria-f.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.concessionaria-f.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.concessionaria-g.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.concessionaria-g.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.mecanica-k.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.mecanica-k.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.mecanica-l.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.mecanica-l.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done
  for container in $(docker ps -a | grep "dev-peer0.financiadora-r.car-lifes-cicle.com-person" | awk '{print $1}'); do
    echo "Removing container $container..."
    docker rm -f "$container" || echo "docker rm of $container failed. Check if all fabric dockers properly was deleted"
  done
  for image in $(docker images "dev-peer0.financiadora-r.car-lifes-cicle.com-person*" -q); do
    echo "Removing image $image..."
    docker rmi "$image" || echo "docker rmi of $image failed. Check if all fabric dockers properly was deleted"
  done

  printf "\nRemoving generated configs... \U1F5D1 \n"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/crypto-config"
  rm -rf "$FABLO_NETWORK_ROOT/fabric-config/chaincode-packages"

  printHeadline "Done! Network was purged" "U1F5D1"
}
