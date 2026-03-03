#!/bin/bash

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
check_command "mktemp"
check_command "printf"
check_command "rm"
check_command "which"
check_command "xargs"

USE_ZH=false
if command -v curl >/dev/null 2>&1; then
    COUNTRY=$(curl -s --connect-timeout 5 https://myip.ipip.net/json | grep -o '"location":\["[^"]*"' | cut -d '"' -f 4 2>/dev/null)
    if [[ "$COUNTRY" == "中国" ]]; then
        USE_ZH=true
    fi
fi

if $USE_ZH; then
    MSG_INTRO=" ###########################################
 #                  注意                   #
 # 如果你想复制特定的应用, 请使用参数      #
 # --app <应用名>                          #
 #                                         #
 # 如果你想指定1Panel的安装路径, 请使用参数#
 # --1panel-path <路径>                    #
 #                                         #
 # 例如, 如果你的1Panel安装在/opt, 请使用: #
 # bash update_local_appstore.sh \\         #
 #   --app app_name_1 \\                    #
 #   --app app_name_2 \\                    #
 #   --1panel-path /opt                    #
 ###########################################"
    MSG_CLEANUP_TEMP="克隆中断, 已删除临时文件夹 %s"
    MSG_CLONE_SUCCESS="从源 %s 克隆成功"
    MSG_CLONE_FAIL="所有源都已尝试, 但克隆失败"
    MSG_COPY_NOTE="仅复制: %s"
    MSG_COPY_SUCCESS="复制成功: %s"
    MSG_ERR_APP_REQUIRE="错误: --app 参数需要指定应用名"
    MSG_ERR_PATH_INVALID="错误: 指定的路径 '%s' 不存在或不是目录"
    MSG_ERR_PATH_REQUIRE="错误: --1panel-path 参数需要指定路径"
    MSG_ERR_MULTI_PATH="错误: 只能指定一个 --1panel-path 参数"
    MSG_ERR_NO_1PANEL="未找到1Panel的安装路径, 使用 --1panel-path 设置1Panel的安装路径, 例如 --1panel-path /opt"
    MSG_LATEST_COMMIT="本地仓库的最新提交: "
    MSG_NOTE_UNKNOWN="注意: 未知参数 %s 被忽略"
    MSG_WARN_APP_MISSING="警告: 应用 '%s' 在仓库中不存在"
    MSG_TRY_CLONE="正在尝试克隆 %s"
else
    MSG_INTRO=" ###########################################
 #                 Note                    #
 # If you want to copy specific apps, use  #
 # --app <app_name> parameter              #
 #                                         #
 # If you want to specify the installation #
 # path of 1Panel, use the                 #
 # --1panel-path <path> parameter          #
 #                                         #
 # For example, if you 1panel is installed #
 # in /opt, use:                           #
 # bash update_local_appstore.sh \\         #
 #   --app app_name_1 \\                    #
 #   --app app_name_2 \\                    #
 #   --1panel-path /opt                    #
 ###########################################"
    MSG_CLEANUP_TEMP="Clone interrupted, temporary directory %s deleted"
    MSG_CLONE_SUCCESS="Successfully cloned from source %s"
    MSG_CLONE_FAIL="All sources have been attempted, but cloning Failed"
    MSG_COPY_NOTE="Only copy: %s"
    MSG_COPY_SUCCESS="Copied success: %s"
    MSG_ERR_APP_REQUIRE="Error: --app parameter requires an app name"
    MSG_ERR_PATH_INVALID="Error: Specified path '%s' does not exist or is not a directory"
    MSG_ERR_PATH_REQUIRE="Error: --1panel-path parameter requires a path"
    MSG_ERR_MULTI_PATH="Error: Only one --1panel-path parameter can be specified"
    MSG_ERR_NO_1PANEL="No installation path found for 1panel, use --1panel-path to specify the installation path, e.g., --1panel-path /opt"
    MSG_LATEST_COMMIT="Latest commit in the local repository:"
    MSG_NOTE_UNKNOWN="Note: Unknown parameter %s ignored"
    MSG_WARN_APP_MISSING="WARNING: App '%s' does not exist in repository"
    MSG_TRY_CLONE="Trying to clone %s"
fi

apps_to_copy=()
custom_base_dir=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --app)
            if [[ -n "$2" && "$2" != --* ]]; then
                apps_to_copy+=("$2")
                shift 2
            else
                echo "$MSG_ERR_APP_REQUIRE"
                exit 1
            fi
            ;;
        --1panel-path)
            if [[ -n "$2" && "$2" != --* ]]; then
                if [[ -n "$custom_base_dir" ]]; then
                    echo "$MSG_ERR_MULTI_PATH"
                    exit 1
                fi
                custom_base_dir="$2"
                if [ ! -d "$custom_base_dir" ]; then
                    printf "$MSG_ERR_PATH_INVALID\n" "$custom_base_dir"
                    exit 1
                fi
                shift 2
            else
                echo "$MSG_ERR_PATH_REQUIRE"
                exit 1
            fi
            ;;
        *)
            printf "$MSG_NOTE_UNKNOWN\n" "$1"
            shift
            ;;
    esac
done

echo "$MSG_INTRO"

if [[ -n "$custom_base_dir" ]]; then
    BASE_DIR="$custom_base_dir"
else
    BASE_DIR=$(which 1pctl | xargs grep '^BASE_DIR=' | cut -d'=' -f2)
    if [ -z "$BASE_DIR" ]; then
        echo "$MSG_ERR_NO_1PANEL"
        exit 1
    fi
fi

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

independent_repos=(
    'https://codeberg.org/pooneyy/1Panel-Appstore.git'
    'https://code.forgejo.org/pooneyy/1Panel-Appstore.git'
    'https://gitea.com/pooneyy/1Panel-Appstore.git'
)

repo_suffix="/pooneyy/1Panel-Appstore.git"
all_urls=()

for prefix in "${repo_prefixs[@]}"; do
    all_urls+=("${prefix}${repo_suffix}")
done

indep_len=${#independent_repos[@]}
indices=()
for ((i=0; i<indep_len; i++)); do
    indices[$i]=$i
done
for ((i=0; i<indep_len; i++)); do
    j=$((RANDOM % (indep_len - i) + i))
    tmp=${indices[i]}
    indices[i]=${indices[j]}
    indices[j]=$tmp
done
for idx in "${indices[@]}"; do
    all_urls+=("${independent_repos[idx]}")
done

TEMP_DIR=$(mktemp -d)
mkdir -p $BASE_DIR/1panel/resource/apps/local/

cleanup_temp_dir() {
    rm -rf $TEMP_DIR
    printf "$MSG_CLEANUP_TEMP\n" "$TEMP_DIR"
    exit 1
}
trap cleanup_temp_dir INT TERM

counter=0
for full_url in "${all_urls[@]}"; do
    printf "$MSG_TRY_CLONE\n" "$full_url"
    git clone --depth 1 -b localApps $full_url $TEMP_DIR > /dev/null 2>&1 && break
    counter=$((counter + 1))
done

if [ $counter -eq ${#all_urls[@]} ]; then
    echo "$MSG_CLONE_FAIL"
else
    printf "$MSG_CLONE_SUCCESS\n" "$full_url"
    echo "$MSG_LATEST_COMMIT"
    git -C $TEMP_DIR log --pretty=format:"%s - %h - %cr(%ci)" -n 1
    
    if [ ${#apps_to_copy[@]} -gt 0 ]; then
        echo ""
        printf "$MSG_COPY_NOTE\n" "${apps_to_copy[*]}"
        for app in "${apps_to_copy[@]}"; do
            if [ -d "$TEMP_DIR/apps/$app" ]; then
                cp -rf "$TEMP_DIR/apps/$app" "$BASE_DIR/1panel/resource/apps/local/"
                printf "$MSG_COPY_SUCCESS\n" "$app"
            else
                printf "$MSG_WARN_APP_MISSING\n" "$app"
            fi
        done
    else
        cp -rf $TEMP_DIR/apps/* $BASE_DIR/1panel/resource/apps/local/
    fi
fi
rm -rf $TEMP_DIR