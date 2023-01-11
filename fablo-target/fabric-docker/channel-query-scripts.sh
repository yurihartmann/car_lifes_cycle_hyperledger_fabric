#!/usr/bin/env bash

source "$FABLO_NETWORK_ROOT/fabric-docker/scripts/channel-query-functions.sh"

set -eu

channelQuery() {
  echo "-> Channel query: " + "$@"

  if [ "$#" -eq 1 ]; then
    printChannelsHelp

  elif [ "$1" = "list" ] && [ "$2" = "gov" ] && [ "$3" = "peer0" ]; then

    peerChannelList "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021"

  elif
    [ "$1" = "list" ] && [ "$2" = "gov" ] && [ "$3" = "peer1" ]
  then

    peerChannelList "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022"

  elif
    [ "$1" = "list" ] && [ "$2" = "montadoraa" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041"

  elif
    [ "$1" = "list" ] && [ "$2" = "montadoraa" ] && [ "$3" = "peer1" ]
  then

    peerChannelList "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042"

  elif
    [ "$1" = "list" ] && [ "$2" = "mecanicaa" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061"

  elif
    [ "$1" = "list" ] && [ "$2" = "mecanicaa" ] && [ "$3" = "peer1" ]
  then

    peerChannelList "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062"

  elif
    [ "$1" = "list" ] && [ "$2" = "seguradoraa" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.seguradora-a.car-lifes-cicle.com" "peer0.seguradora-a.car-lifes-cicle.com:7081"

  elif
    [ "$1" = "list" ] && [ "$2" = "seguradoraa" ] && [ "$3" = "peer1" ]
  then

    peerChannelList "cli.seguradora-a.car-lifes-cicle.com" "peer1.seguradora-a.car-lifes-cicle.com:7082"

  elif

    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "gov" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.gov.car-lifes-cicle.com" "peer0.gov.car-lifes-cicle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "gov" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.gov.car-lifes-cicle.com" "$TARGET_FILE" "peer0.gov.car-lifes-cicle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "gov" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.gov.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.gov.car-lifes-cicle.com:7021" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "gov" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.gov.car-lifes-cicle.com" "peer1.gov.car-lifes-cicle.com:7022"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "gov" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.gov.car-lifes-cicle.com" "$TARGET_FILE" "peer1.gov.car-lifes-cicle.com:7022"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "gov" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.gov.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.gov.car-lifes-cicle.com:7022" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "montadoraa" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.montadora-a.car-lifes-cicle.com" "peer0.montadora-a.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "montadoraa" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.montadora-a.car-lifes-cicle.com" "$TARGET_FILE" "peer0.montadora-a.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "montadoraa" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.montadora-a.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.montadora-a.car-lifes-cicle.com:7041" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "montadoraa" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.montadora-a.car-lifes-cicle.com" "peer1.montadora-a.car-lifes-cicle.com:7042"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "montadoraa" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.montadora-a.car-lifes-cicle.com" "$TARGET_FILE" "peer1.montadora-a.car-lifes-cicle.com:7042"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "montadoraa" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.montadora-a.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.montadora-a.car-lifes-cicle.com:7042" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "mecanicaa" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.mecanica-a.car-lifes-cicle.com" "peer0.mecanica-a.car-lifes-cicle.com:7061"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "mecanicaa" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.mecanica-a.car-lifes-cicle.com" "$TARGET_FILE" "peer0.mecanica-a.car-lifes-cicle.com:7061"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "mecanicaa" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.mecanica-a.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.mecanica-a.car-lifes-cicle.com:7061" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "mecanicaa" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.mecanica-a.car-lifes-cicle.com" "peer1.mecanica-a.car-lifes-cicle.com:7062"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "mecanicaa" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.mecanica-a.car-lifes-cicle.com" "$TARGET_FILE" "peer1.mecanica-a.car-lifes-cicle.com:7062"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "mecanicaa" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.mecanica-a.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.mecanica-a.car-lifes-cicle.com:7062" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "seguradoraa" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.seguradora-a.car-lifes-cicle.com" "peer0.seguradora-a.car-lifes-cicle.com:7081"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "seguradoraa" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.seguradora-a.car-lifes-cicle.com" "$TARGET_FILE" "peer0.seguradora-a.car-lifes-cicle.com:7081"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "seguradoraa" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.seguradora-a.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.seguradora-a.car-lifes-cicle.com:7081" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-lifes-cicle-channel" ] && [ "$3" = "seguradoraa" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "car-lifes-cicle-channel" "cli.seguradora-a.car-lifes-cicle.com" "peer1.seguradora-a.car-lifes-cicle.com:7082"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "seguradoraa" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-lifes-cicle-channel" "cli.seguradora-a.car-lifes-cicle.com" "$TARGET_FILE" "peer1.seguradora-a.car-lifes-cicle.com:7082"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-lifes-cicle-channel" ] && [ "$4" = "seguradoraa" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-lifes-cicle-channel" "cli.seguradora-a.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.seguradora-a.car-lifes-cicle.com:7082" "$TARGET_FILE"

  else

    echo "$@"
    echo "$1, $2, $3, $4, $5, $6, $7, $#"
    printChannelsHelp
  fi

}

printChannelsHelp() {
  echo "Channel management commands:"
  echo ""

  echo "fablo channel list gov peer0"
  echo -e "\t List channels on 'peer0' of 'Gov'".
  echo ""

  echo "fablo channel list gov peer1"
  echo -e "\t List channels on 'peer1' of 'Gov'".
  echo ""

  echo "fablo channel list montadoraa peer0"
  echo -e "\t List channels on 'peer0' of 'montadoraA'".
  echo ""

  echo "fablo channel list montadoraa peer1"
  echo -e "\t List channels on 'peer1' of 'montadoraA'".
  echo ""

  echo "fablo channel list mecanicaa peer0"
  echo -e "\t List channels on 'peer0' of 'mecanicaA'".
  echo ""

  echo "fablo channel list mecanicaa peer1"
  echo -e "\t List channels on 'peer1' of 'mecanicaA'".
  echo ""

  echo "fablo channel list seguradoraa peer0"
  echo -e "\t List channels on 'peer0' of 'seguradoraA'".
  echo ""

  echo "fablo channel list seguradoraa peer1"
  echo -e "\t List channels on 'peer1' of 'seguradoraA'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel gov peer0"
  echo -e "\t Get channel info on 'peer0' of 'Gov'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel gov peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'Gov'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel gov peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'Gov'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel gov peer1"
  echo -e "\t Get channel info on 'peer1' of 'Gov'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel gov peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'Gov'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel gov peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'Gov'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel montadoraa peer0"
  echo -e "\t Get channel info on 'peer0' of 'montadoraA'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel montadoraa peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'montadoraA'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel montadoraa peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'montadoraA'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel montadoraa peer1"
  echo -e "\t Get channel info on 'peer1' of 'montadoraA'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel montadoraa peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'montadoraA'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel montadoraa peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'montadoraA'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel mecanicaa peer0"
  echo -e "\t Get channel info on 'peer0' of 'mecanicaA'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel mecanicaa peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'mecanicaA'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel mecanicaa peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'mecanicaA'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel mecanicaa peer1"
  echo -e "\t Get channel info on 'peer1' of 'mecanicaA'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel mecanicaa peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'mecanicaA'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel mecanicaa peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'mecanicaA'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel seguradoraa peer0"
  echo -e "\t Get channel info on 'peer0' of 'seguradoraA'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel seguradoraa peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'seguradoraA'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel seguradoraa peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'seguradoraA'".
  echo ""

  echo "fablo channel getinfo car-lifes-cicle-channel seguradoraa peer1"
  echo -e "\t Get channel info on 'peer1' of 'seguradoraA'".
  echo ""
  echo "fablo channel fetch config car-lifes-cicle-channel seguradoraa peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'seguradoraA'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-lifes-cicle-channel seguradoraa peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'seguradoraA'".
  echo ""

}
