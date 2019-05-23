#!/bin/bash

# Exit on errors
set -e

echo -e "\nKicking off creation for ${SITE_NAME}..."

# login to Terminus
echo -e "\nLogging into Terminus..."
terminus auth:login --machine-token=${TERMINUS_MACHINE_TOKEN} > /dev/null 2>&1

# Helper to see if a site exists already
TERMINUS_DOES_SITE_EXIST()
{
    
    # Stash list of Pantheon multidev environments
    PANTHEON_ORG_SITE_LIST="$(terminus org:site:list -n ${ORG_UUID} --format=list --field=Name)"

    while read -r CURRENT_SITE; do
        if [[ "${CURRENT_SITE}" == "$1" ]]
        then
            return 0;
        fi
    done <<< "$PANTHEON_ORG_SITE_LIST"

    return 1;
}

# Check if the site already exists
if TERMINUS_DOES_SITE_EXIST ${SITE_NAME}
then
    echo -e "The site ${SITE_NAME} already exists, aborting site creation.\n"
    exit 0
fi

# Create the site
terminus build:project:create \
--org="${GITHUB_ORG}" --team="${ORG_UUID}" --email="${GIT_EMAIL}" \
--admin-email="${CMS_EMAIL}" --admin-password="${CMS_PASSWORD}" \
--ci="circleci" --git="github" \
--stability=dev ${BASE_PROJECT} ${SITE_NAME}

# Activate WordPress plugins on dev
terminus wp ${SITE_NAME}.dev -- plugin activate --all

# Add the student to the Pantheon site
echo -e "\nAdding the student to the Pantheon site ${SITE_NAME}."
terminus site:team:add ${SITE_NAME} ${STUDENT_PANTHEON_EMAIL} team_member

# Add the student to the GitHub repository
echo -e "\nAdding the student to the GitHub repository ${SITE_NAME}."
hub api repos/${GITHUB_ORG}/${SITE_NAME}/collaborators/${STUDENT_GIT_USERNAME} --field "permission=push" --method "PUT" > /dev/null 2>&1

# If we've gotten this far things went well
echo -e "\n${SITE_NAME} created successfully! Check it out at ${DEV_URL} or https://github.com/${GITHUB_ORG}/${SITE_NAME}."
exit 0