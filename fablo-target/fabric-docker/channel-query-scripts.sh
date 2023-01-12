#!/usr/bin/env bash

source "$FABLO_NETWORK_ROOT/fabric-docker/scripts/channel-query-functions.sh"

set -eu

channelQuery() {
  echo "-> Channel query: " + "$@"

  if [ "$#" -eq 1 ]; then
    printChannelsHelp

  elif [ "$1" = "list" ] && [ "$2" = "detran" ] && [ "$3" = "peer0" ]; then

    peerChannelList "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021"

  elif
    [ "$1" = "list" ] && [ "$2" = "detran" ] && [ "$3" = "peer1" ]
  then

    peerChannelList "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022"

  elif
    [ "$1" = "list" ] && [ "$2" = "montadora" ] && [ "$3" = "peer0" ]
  then

    peerChannelList "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041"

  elif
    [ "$1" = "list" ] && [ "$2" = "montadora" ] && [ "$3" = "peer1" ]
  then

    peerChannelList "cli.montadora.car-lifes-cicle.com" "peer1.montadora.car-lifes-cicle.com:7042"

  elif

    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "detran" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.detran.car-lifes-cicle.com" "$TARGET_FILE" "peer0.detran.car-lifes-cicle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.detran.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.detran.car-lifes-cicle.com:7021" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "detran" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "car-channel" "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.detran.car-lifes-cicle.com" "$TARGET_FILE" "peer1.detran.car-lifes-cicle.com:7022"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.detran.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.detran.car-lifes-cicle.com:7022" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "montadora" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "car-channel" "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.montadora.car-lifes-cicle.com" "$TARGET_FILE" "peer0.montadora.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.montadora.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.montadora.car-lifes-cicle.com:7041" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "car-channel" ] && [ "$3" = "montadora" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "car-channel" "cli.montadora.car-lifes-cicle.com" "peer1.montadora.car-lifes-cicle.com:7042"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "car-channel" "cli.montadora.car-lifes-cicle.com" "$TARGET_FILE" "peer1.montadora.car-lifes-cicle.com:7042"

  elif [ "$1" = "fetch" ] && [ "$3" = "car-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "car-channel" "cli.montadora.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.montadora.car-lifes-cicle.com:7042" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "person-channel" ] && [ "$3" = "detran" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "person-channel" "cli.detran.car-lifes-cicle.com" "peer0.detran.car-lifes-cicle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "person-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "person-channel" "cli.detran.car-lifes-cicle.com" "$TARGET_FILE" "peer0.detran.car-lifes-cicle.com:7021"

  elif [ "$1" = "fetch" ] && [ "$3" = "person-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "person-channel" "cli.detran.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.detran.car-lifes-cicle.com:7021" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "person-channel" ] && [ "$3" = "detran" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "person-channel" "cli.detran.car-lifes-cicle.com" "peer1.detran.car-lifes-cicle.com:7022"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "person-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "person-channel" "cli.detran.car-lifes-cicle.com" "$TARGET_FILE" "peer1.detran.car-lifes-cicle.com:7022"

  elif [ "$1" = "fetch" ] && [ "$3" = "person-channel" ] && [ "$4" = "detran" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "person-channel" "cli.detran.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.detran.car-lifes-cicle.com:7022" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "person-channel" ] && [ "$3" = "montadora" ] && [ "$4" = "peer0" ]
  then

    peerChannelGetInfo "person-channel" "cli.montadora.car-lifes-cicle.com" "peer0.montadora.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "person-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer0" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "person-channel" "cli.montadora.car-lifes-cicle.com" "$TARGET_FILE" "peer0.montadora.car-lifes-cicle.com:7041"

  elif [ "$1" = "fetch" ] && [ "$3" = "person-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer0" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "person-channel" "cli.montadora.car-lifes-cicle.com" "${BLOCK_NAME}" "peer0.montadora.car-lifes-cicle.com:7041" "$TARGET_FILE"

  elif
    [ "$1" = "getinfo" ] && [ "$2" = "person-channel" ] && [ "$3" = "montadora" ] && [ "$4" = "peer1" ]
  then

    peerChannelGetInfo "person-channel" "cli.montadora.car-lifes-cicle.com" "peer1.montadora.car-lifes-cicle.com:7042"

  elif [ "$1" = "fetch" ] && [ "$2" = "config" ] && [ "$3" = "person-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer1" ]; then
    TARGET_FILE=${6:-"$channel-config.json"}

    peerChannelFetchConfig "person-channel" "cli.montadora.car-lifes-cicle.com" "$TARGET_FILE" "peer1.montadora.car-lifes-cicle.com:7042"

  elif [ "$1" = "fetch" ] && [ "$3" = "person-channel" ] && [ "$4" = "montadora" ] && [ "$5" = "peer1" ]; then
    BLOCK_NAME=$2
    TARGET_FILE=${6:-"$BLOCK_NAME.block"}

    peerChannelFetchBlock "person-channel" "cli.montadora.car-lifes-cicle.com" "${BLOCK_NAME}" "peer1.montadora.car-lifes-cicle.com:7042" "$TARGET_FILE"

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

  echo "fablo channel list detran peer1"
  echo -e "\t List channels on 'peer1' of 'detran'".
  echo ""

  echo "fablo channel list montadora peer0"
  echo -e "\t List channels on 'peer0' of 'montadora'".
  echo ""

  echo "fablo channel list montadora peer1"
  echo -e "\t List channels on 'peer1' of 'montadora'".
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

  echo "fablo channel getinfo car-channel detran peer1"
  echo -e "\t Get channel info on 'peer1' of 'detran'".
  echo ""
  echo "fablo channel fetch config car-channel detran peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'detran'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel detran peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'detran'".
  echo ""

  echo "fablo channel getinfo car-channel montadora peer0"
  echo -e "\t Get channel info on 'peer0' of 'montadora'".
  echo ""
  echo "fablo channel fetch config car-channel montadora peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'montadora'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel montadora peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'montadora'".
  echo ""

  echo "fablo channel getinfo car-channel montadora peer1"
  echo -e "\t Get channel info on 'peer1' of 'montadora'".
  echo ""
  echo "fablo channel fetch config car-channel montadora peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'montadora'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> car-channel montadora peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'montadora'".
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

  echo "fablo channel getinfo person-channel detran peer1"
  echo -e "\t Get channel info on 'peer1' of 'detran'".
  echo ""
  echo "fablo channel fetch config person-channel detran peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'detran'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> person-channel detran peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'detran'".
  echo ""

  echo "fablo channel getinfo person-channel montadora peer0"
  echo -e "\t Get channel info on 'peer0' of 'montadora'".
  echo ""
  echo "fablo channel fetch config person-channel montadora peer0 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer0' of 'montadora'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> person-channel montadora peer0 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer0' of 'montadora'".
  echo ""

  echo "fablo channel getinfo person-channel montadora peer1"
  echo -e "\t Get channel info on 'peer1' of 'montadora'".
  echo ""
  echo "fablo channel fetch config person-channel montadora peer1 [file-name.json]"
  echo -e "\t Download latest config block and save it. Uses first peer 'peer1' of 'montadora'".
  echo ""
  echo "fablo channel fetch <newest|oldest|block-number> person-channel montadora peer1 [file name]"
  echo -e "\t Fetch a block with given number and save it. Uses first peer 'peer1' of 'montadora'".
  echo ""

}
