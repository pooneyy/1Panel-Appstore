check_command() {
    command -v "$1" > /dev/null 2>&1 || {
        echo >&2 "未找到 $1 命令"
        exit 1
    }
}

check_command "cp"
check_command "cut"
check_command "git"
check_command "grep"
check_command "rm"
check_command "which"
check_command "xargs"

BASE_DIR=$(which 1pctl | xargs grep '^BASE_DIR=' | cut -d'=' -f2)
if [ -z "$BASE_DIR" ]; then
    echo "未找到 1panel 的安装路径"
    exit 1
fi

TEMP_DIR="/tmp/localApps"

repo_prefixs=(
    'https://github.com'
    'https://gh-proxy.com/https://github.com'
    'https://edgeone.gh-proxy.com/https://github.com'
    'https://gh-proxy.net/github.com'
    'https://kkgithub.com'
    'https://wget.la/https://github.com'
    'https://ghfast.top/https://github.com'
    'https://githubfast.com'
    'https://ghproxy.net/https://github.com'
)

repo_suffix="/pooneyy/1Panel-Appstore.git"

for repo_prefix in "${repo_prefixs[@]}"; do
    git clone --depth 1 -b localApps $repo_prefix$repo_suffix $TEMP_DIR && break
done

cp -rf $TEMP_DIR/apps/* $BASE_DIR/1panel/resource/apps/local/

rm -rf $TEMP_DIR
