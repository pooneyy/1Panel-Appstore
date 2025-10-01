# Simple Github Action Runner In Docker

![](http://fastly.jsdelivr.net/gh/actions/runner@main/docs/res/github-graph.png)

A simple self-hosted actions runner running in a container

## Features

- Supports Docker-in-Docker

### Environment Variables
| Parameter | Required | Description |
| --- | --- | --- |
| `ROLE` | Required | Used to differentiate between enterprise, organization, and personal repositories.<br />Use `enterprises` for enterprise, `orgs` for organization, and `repos` for personal repositories.<br />**REST API** |
| `REPO` | Required | Format for enterprise: `enterpriseName`<br />Format for organization: `orgName`<br />Format for personal repository: `owner/repo`<br />**REST API** |
| `RUNNER_GITHUB_TOKEN` | Required | [Fine-grained PAT is recommended](https://github.com/settings/personal-access-tokens/new).<br />For enterprises:<br />**Fine-grained PAT cannot be used for enterprises**<br />OAuth app tokens and PAT (classic) require the `manage_runners:enterprise` permission.<br />For organizations:<br />Fine-grained PAT should have read and write permissions for Self-hosted runners.<br />OAuth tokens and PAT (classic) require `admin:org` permissions,<br />additionally, `repo` permissions are required for private organization repositories.<br />For personal repositories:<br />Fine-grained PAT should have read and write permissions for Administration.<br />OAuth tokens and PAT (classic) require `repo` permissions.<br />[How to create a token?](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)<br />**REST API** |
| `RUNNER_NAME` | | Runner name. If left empty, it will be randomly generated.<br />Runner names must be unique within the same personal repository (or enterprise/organization). |
| `RUNNER_LABELS` | | Runner labels. Filling this will add new labels..<br />Use commas to separate multiple labels.<br />Example: `label1,label2` |
| `WORK_FOLDER` | | Working directory. If left empty, it will be randomly generated. Rarely needed. |
| `RUNNER_GROUP` | | Runner group. The default value is `Default`. For details, refer to the [documentation](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/manage-access). |
| `AUTO_UNREGISTER` | | Whether to unregister the Runner from github.com when the container stops. <br />Default is `false`. It is recommended to map /home/runner/.runner_config <br />to a local when selecting false. This folder saves Runner's login status. |

For parameters marked with **REST API**, refer to the [documentation](https://docs.github.com/en/enterprise-cloud@latest/rest/actions/self-hosted-runners?apiVersion=2022-11-28).
