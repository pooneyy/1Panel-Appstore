# Github Action Runner

![](https://fastly.jsdelivr.net/gh/actions/runner@main/docs/res/github-graph.png)

运行在容器中的简单的自托管 GitHub Actions 运行器

## 功能

- 支持 Docker-in-Docker

### 环境变量
| 参数 | 是否必须 | 说明 |
| --- | --- | --- |
| `ROLE` | 必须 | 用于区分企业、组织与个人仓库<br/>企业为 `enterprises` 组织为 `orgs` ，个人仓库为 `repos`<br/>**REST API** |
| `REPO` | 必须 | 企业格式为`enterpriseName`<br/>组织格式为`orgName`<br/>个人仓库格式为 `owner/repo`<br/>**REST API** |
| `RUNNER_GITHUB_TOKEN` | 必须 | [推荐 Fine-grained PAT](https://github.com/settings/personal-access-tokens/new)。<br />对于企业：<br />**Fine-grained PAT 不能用于企业**<br />OAuth 应用令牌和PAT（classic）需要 `manage_runners:enterprise` 权限。<br />对于组织：<br/>应具备 Self-hosted runners 的读写权限。<br />OAuth 令牌和PAT（classic）需要 `admin:org` 权限，<br />此外私有组织仓库还需要 `repo` 权限。<br />对于个人仓库：<br/>应具备 Administration 的读写权限。<br />OAuth 令牌和PAT（classic）需要 `repo` 权限。<br />[如何创建令牌？](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)<br />**REST API** |
| `RUNNER_NAME` | | Runner 名称，留空随机生成。<br />在同一个个人仓库（或企业、组织）中 Runner 名称不能重复。 |
| `RUNNER_LABELS` | | Runner 标签，填写此项会增加新的标签，<br>若填入多个标签则用半角逗号分隔。<br>示例: `label1,label2` |
| `WORK_FOLDER` | | 工作文件夹，留空随机生成，几乎用不上。 |
| `RUNNER_GROUP` | | Runner 组，默认值为`Default`，具体参见[文档](https://docs.github.com/en/actions/how-tos/manage-runners/self-hosted-runners/manage-access)。 |
| `AUTO_UNREGISTER` | | 是否在容器停止时从 github.com 注销 Runner，默认为 `false`。 |

关于标注了**REST API**的问题，参考[文档](https://docs.github.com/en/enterprise-cloud@latest/rest/actions/self-hosted-runners?apiVersion=2022-11-28)。
