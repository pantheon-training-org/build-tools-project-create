#!/bin/bash

# Bail if required environment variables are missing
if [ -z "$SITE_NAME" ]
then
  echo -e "\nSITE_NAME is not defined, aborting..."
  exit 1
fi

if [ -z "$ORG_UUID" ]
then
  echo -e "\nORG_UUID is not defined, aborting..."
  exit 1
fi

if [ -z "$TERMINUS_MACHINE_TOKEN" ]
then
  echo -e "\nTERMINUS_MACHINE_TOKEN is not defined, aborting..."
  exit 1
fi

if [ -z "$GITHUB_TOKEN" ]
then
  echo -e "\nGITHUB_TOKEN is not defined, aborting..."
  exit 1
fi

if [ -z "$GITHUB_ORG" ]
then
  echo -e "\nGITHUB_ORG is not defined, aborting..."
  exit 1
fi

if [ -z "$GITHUB_EMAIL" ]
then
  echo -e "\nGITHUB_ORG is not defined, aborting..."
  exit 1
fi

if [ -z "$CIRCLE_TOKEN" ]
then
  echo -e "\nCIRCLE_TOKEN is not defined, aborting..."
  exit 1
fi

if [ -z "$DRUPAL_EMAIL" ]
then
  echo -e "\nDRUPAL_EMAIL is not defined, aborting..."
  exit 1
fi

if [ -z "$DRUPAL_PASS" ]
then
  echo -e "\nDRUPAL_PASS is not defined, aborting..."
  exit 1
fi

set -ex


# Stash site URLs
echo "export DEV_URL='https://dev-$SITE_NAME.pantheonsite.io/'" >> $BASH_ENV
echo "export LIVE_URL='https://live-$SITE_NAME.pantheonsite.io/'" >> $BASH_ENV
echo 'export PATH=$PATH:$HOME/bin:$HOME/terminus/bin' >> $BASH_ENV

source $BASH_ENV

#===========================================
# End EXPORTing needed environment variables
#===========================================

# Bail on errors
set +ex

# Disable host checking
if [ ! -d $HOME/.ssh ]
then
	mkdir -p $HOME/.ssh
fi
touch $HOME/.ssh/config
echo "StrictHostKeyChecking no" >> "$HOME/.ssh/config"