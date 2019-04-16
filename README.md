# pantheon-training-org/build-tools-project-create

This repository assists with bulk project creation by running `terminus build:project:create` from [Terminus Build Tools](https://github.com/pantheon-systems/terminus-build-tools-plugin/) on CircleCI by [triggering jobs through the CircleCI API](https://circleci.com/docs/2.0/api-job-trigger).


** Step to run the script **

- Clone https://github.com/pantheon-training-org/build-tools-project-create locally.
- Update this project's [CircleCI environment variables](https://circleci.com/gh/pantheon-training-org/build-tools-project-create/edit#env-vars). Here are a few items you may wish to update:
    - `CMS_EMAIL`: The email associated with the `admin` CMS user account.
    - `CMS_PASSWORD`: The password used to install the CMS.
    - `GITHUB_ORG`: GitHub organization to create projects under.
    - `ORG_UUID`: UUID of the Pantheon organization to add the sites to.
- Make a `sites-to-create.json` file containing an array of project details for each `build:project:create` run.
    - `SITE_NAME`: a slug for the project. This will typically have the students first initial + last name and the event name + year. For example, `ataylor-drupalcon-seattle-2019`.
    - `STUDENT_PANTHEON_EMAIL`: The email address associated with a Pantheon user account to be added to the project.
    - `BASE_PROJECT`: The base project type to create. This can be `wp`, `d8`, or a custom GitHub repository URL. For example, `pantheon-systems/example-wordpress-composer:dev-master`.
    - `STUDENT_GIT_USERNAME`: A GitHub user account to be added to the project.
- Run `export CIRCLE_TOKEN=` with a valid CircleCI token
- Run `create-sites.sh` locally, which will loop through all the project details in `sites-to-create.json` and call the CircleCI API to start a job for each project.
- [Watch the jobs appear in CircleCI](https://circleci.com/gh/pantheon-training-org/build-tools-project-create/tree/master)

`sites-to-create.json` example:
```json
[
	{
		"SITE_NAME": "ataylor-drupalcon-seattle-2019",
		"STUDENT_PANTHEON_EMAIL": "andrew@getpantheon.com",
		"BASE_PROJECT": "pantheon-systems/example-drops-8-composer:dev-master",
		"STUDENT_GIT_USERNAME": "ataylorme"
	}
]
```