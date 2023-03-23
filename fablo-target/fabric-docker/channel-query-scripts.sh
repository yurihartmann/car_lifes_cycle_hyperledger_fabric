#!/usr/bin/env bash

source "$FABLO_NETWORK_ROOT/fabric-docker/scripts/channel-query-functions.sh"

set -eu

channelQuery() {
  echo "-> Channel query: " + "$@"

  if [ "$#" -eq 1 ]; then
    printChannelsHelp

  elif [ "$1" = "list" ] && [ "$2" = "detran" ] && [ "$3" = "peer0" ]; then

    peerChannelList "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021"

  elif
    [ "$1" = "list" ] && [ "$2" = "gov" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041"

  elif
    [ "$1" = "list" ] && [ "$2" = "montadorac" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061"

  elif
    [ "$1" = "list" ] && [ "$2" = "montadorad" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081"

  elif
    [ "$1" = "list" ] && [ "$2" = "concessionarif" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101"

  elif
    [ "$1" = "list" ] && [ "$2" = "concessionarig" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121"

  elif
    [ "$1" = "list" ] && [ "$2" = "mecanicak" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141"

  elif
    [ "$1" = "list" ] && [ "$2" = "mecanical" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161"

  elif
    [ "$1" = "list" ] && [ "$2" = "financiadorar" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181"

  elif

    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "detran" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.detran.car-lifes-cycle.com" "$TARGET_FILE" "peer0.detran.car-lifes-cycle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.detran.car-lifes-cycle.com" "${BLOCK_NAME}" "peer0.detran.car-lifes-cycle.com:7021" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "montadorac" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.montadora-c.car-lifes-cicle.com" "peer0.montadora-c.car-lifes-cicle.com:7061"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadorac" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.montadora-c.car-lifes-cicle.com" "$TARGET_FILE" "peer0.montadora-c.car-lifes-cicle.com:7061"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadorac" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.montadora-c.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.montadora-c.car-lifes-cicle.com:7061" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "montadorad" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.montadora-d.car-lifes-cicle.com" "peer0.montadora-d.car-lifes-cicle.com:7081"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadorad" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.montadora-d.car-lifes-cicle.com" "$TARGET_FILE" "peer0.montadora-d.car-lifes-cicle.com:7081"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadorad" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.montadora-d.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.montadora-d.car-lifes-cicle.com:7081" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "concessionarif" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.concessionaria-f.car-lifes-cicle.com" "peer0.concessionaria-f.car-lifes-cicle.com:7101"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "concessionarif" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.concessionaria-f.car-lifes-cicle.com" "$TARGET_FILE" "peer0.concessionaria-f.car-lifes-cicle.com:7101"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "concessionarif" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.concessionaria-f.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.concessionaria-f.car-lifes-cicle.com:7101" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "concessionarig" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.concessionaria-g.car-lifes-cicle.com" "peer0.concessionaria-g.car-lifes-cicle.com:7121"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "concessionarig" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.concessionaria-g.car-lifes-cicle.com" "$TARGET_FILE" "peer0.concessionaria-g.car-lifes-cicle.com:7121"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "concessionarig" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.concessionaria-g.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.concessionaria-g.car-lifes-cicle.com:7121" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "mecanicak" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.mecanica-k.car-lifes-cicle.com" "peer0.mecanica-k.car-lifes-cicle.com:7141"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "mecanicak" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.mecanica-k.car-lifes-cicle.com" "$TARGET_FILE" "peer0.mecanica-k.car-lifes-cicle.com:7141"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "mecanicak" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.mecanica-k.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.mecanica-k.car-lifes-cicle.com:7141" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "mecanical" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.mecanica-l.car-lifes-cicle.com" "peer0.mecanica-l.car-lifes-cicle.com:7161"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "mecanical" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.mecanica-l.car-lifes-cicle.com" "$TARGET_FILE" "peer0.mecanica-l.car-lifes-cicle.com:7161"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "mecanical" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.mecanica-l.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.mecanica-l.car-lifes-cicle.com:7161" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "financiadorar" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.financiadora-r.car-lifes-cicle.com" "peer0.financiadora-r.car-lifes-cicle.com:7181"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "financiadorar" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.financiadora-r.car-lifes-cicle.com" "$TARGET_FILE" "peer0.financiadora-r.car-lifes-cicle.com:7181"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "financiadorar" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.financiadora-r.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.financiadora-r.car-lifes-cicle.com:7181" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "person-channel" ] && [ "$3" = "detran" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "person-channel" "cli.detran.car-lifes-cycle.com" "peer0.detran.car-lifes-cycle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "person-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "person-channel" "cli.detran.car-lifes-cycle.com" "$TARGET_FILE" "peer0.detran.car-lifes-cycle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$3" = "person-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "person-channel" "cli.detran.car-lifes-cycle.com" "${BLOCK_NAME}" "peer0.detran.car-lifes-cycle.com:7021" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "person-channel" ] && [ "$3" = "gov" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "person-channel" "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "person-channel" ] && [ "$4" = "gov" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "person-channel" "cli.gov.car-lifes-cicle.com" "$TARGET_FILE" "peer0.gov.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$3" = "person-channel" ] && [ "$4" = "gov" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "person-channel" "cli.gov.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.gov.car-lifes-cicle.com:7041" "$TARGET_FILE"

  else

    echo "$@"
    echo "$1, $2, $3, $4, $5, $6, $7, $#"
    printChannelsHelp
  fi

}

printChannelsHelp() {
  echo "Channel management commands:"
  echo ""

  echo "fablo channel list detran peer0"
  echo -e "\t List channels on 'peer0' of 'detran'".
  echo ""

  echo "fablo channel list gov peer0"
  echo -e "\t List channels on 'peer0' of 'gov'".
  echo ""

  echo "fablo channel list montadorac peer0"
  echo -e "\t List channels on 'peer0' of 'montadoraC'".
  echo ""

  echo "fablo channel list montadorad peer0"
  echo -e "\t List channels on 'peer0' of 'montadoraD'".
  echo ""

  echo "fablo channel list concessionarif peer0"
  echo -e "\t List channels on 'peer0' of 'concessionariF'".
  echo ""

  echo "fablo channel list concessionarig peer0"
  echo -e "\t List channels on 'peer0' of 'concessionariG'".
  echo ""

  echo "fablo channel list mecanicak peer0"
  echo -e "\t List channels on 'peer0' of 'mecanicaK'".
  echo ""

  echo "fablo channel list mecanical peer0"
  echo -e "\t List channels on 'peer0' of 'mecanicaL'".
  echo ""

  echo "fablo channel list financiadorar peer0"
  echo -e "\t List channels on 'peer0' of 'financiadoraR'".
  echo ""

  echo "fablo channel getinfo car-channel detran peer0"
  echo -e "\t Get channel info on 'peer0' of 'detran'".
  echo ""
  echo "fablo channel fetch config car-channel detran peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'detran'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel detran peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'detran'".
  echo ""

  echo "fablo channel getinfo car-channel montadorac peer0"
  echo -e "\t Get channel info on 'peer0' of 'montadoraC'".
  echo ""
  echo "fablo channel fetch config car-channel montadorac peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'montadoraC'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel montadorac peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'montadoraC'".
  echo ""

  echo "fablo channel getinfo car-channel montadorad peer0"
  echo -e "\t Get channel info on 'peer0' of 'montadoraD'".
  echo ""
  echo "fablo channel fetch config car-channel montadorad peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'montadoraD'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel montadorad peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'montadoraD'".
  echo ""

  echo "fablo channel getinfo car-channel concessionarif peer0"
  echo -e "\t Get channel info on 'peer0' of 'concessionariF'".
  echo ""
  echo "fablo channel fetch config car-channel concessionarif peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'concessionariF'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel concessionarif peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'concessionariF'".
  echo ""

  echo "fablo channel getinfo car-channel concessionarig peer0"
  echo -e "\t Get channel info on 'peer0' of 'concessionariG'".
  echo ""
  echo "fablo channel fetch config car-channel concessionarig peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'concessionariG'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel concessionarig peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'concessionariG'".
  echo ""

  echo "fablo channel getinfo car-channel mecanicak peer0"
  echo -e "\t Get channel info on 'peer0' of 'mecanicaK'".
  echo ""
  echo "fablo channel fetch config car-channel mecanicak peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'mecanicaK'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel mecanicak peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'mecanicaK'".
  echo ""

  echo "fablo channel getinfo car-channel mecanical peer0"
  echo -e "\t Get channel info on 'peer0' of 'mecanicaL'".
  echo ""
  echo "fablo channel fetch config car-channel mecanical peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'mecanicaL'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel mecanical peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'mecanicaL'".
  echo ""

  echo "fablo channel getinfo car-channel financiadorar peer0"
  echo -e "\t Get channel info on 'peer0' of 'financiadoraR'".
  echo ""
  echo "fablo channel fetch config car-channel financiadorar peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'financiadoraR'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel financiadorar peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'financiadoraR'".
  echo ""

  echo "fablo channel getinfo person-channel detran peer0"
  echo -e "\t Get channel info on 'peer0' of 'detran'".
  echo ""
  echo "fablo channel fetch config person-channel detran peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'detran'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> person-channel detran peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'detran'".
  echo ""

  echo "fablo channel getinfo person-channel gov peer0"
  echo -e "\t Get channel info on 'peer0' of 'gov'".
  echo ""
  echo "fablo channel fetch config person-channel gov peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'gov'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> person-channel gov peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'gov'".
  echo ""

}
