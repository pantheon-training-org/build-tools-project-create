#!/bin/bash

# Bail on errors
set +ex

if [ -z "$CIRCLE_TOKEN" ]
then
  echo -e "\nCIRCLE_TOKEN is not defined, aborting..."
  exit 1
fi

if [ -f sites-to-create.json ]
then
  echo -e "\nsites-to-create.json is missing, aborting..."
  exit 1
fi

# Read which sites to update from sites-to-create.json
while IFS= read -r SITE_NAME &&
	IFS= read -r STUDENT_PANTHEON_EMAIL; do

	echo -e "\nStarting create-drops-8 via API for ${SITE_NAME}..."

    curl --user ${CIRCLE_TOKEN}: \
				--data build_parameters[CIRCLE_JOB]=build \
				--data build_parameters[SITE_NAME]=$SITE_NAME \
				--data build_parameters[STUDENT_PANTHEON_EMAIL]=$STUDENT_PANTHEON_EMAIL \
				https://circleci.com/api/v1.1/project/github/pantheon-training-org/build-tools-project-create/tree/master  >/dev/null

done < <(jq -r '.[] | (.SITE_NAME, .STUDENT_PANTHEON_EMAIL)' < "$(dirname "$pwd")/sites-to-create.json")