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
    MSG_ERR_CLONE_SOURCE_REQUIRE="错误: --clone-source 参数需要指定源名称"
    MSG_ERR_UNKNOWN_SOURCE="错误: 未知的源 '%s'"
    MSG_DRY_RUN_MODE="试运行模式已启用，不会执行任何实际更改"
    MSG_DRY_RUN_URL_HEADER="将按以下顺序克隆 URL："
    MSG_DRY_RUN_URL="将克隆: %s"
    MSG_DRY_RUN_TARGET_DIR_EXISTS="目标目录 %s 存在"
    MSG_DRY_RUN_TARGET_DIR_NOT_EXISTS="目标目录 %s 不存在"
    MSG_DRY_RUN_COPY="将复制应用 '%s' 到 %s"
    MSG_DRY_RUN_COPY_ALL="将复制所有应用到 %s"
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
    MSG_ERR_CLONE_SOURCE_REQUIRE="Error: --clone-source parameter requires a source name"
    MSG_ERR_UNKNOWN_SOURCE="Error: Unknown source '%s'"
    MSG_DRY_RUN_MODE="Dry run mode enabled, no changes will be made"
    MSG_DRY_RUN_URL_HEADER="URLs to be cloned (in order):"
    MSG_DRY_RUN_URL="Would clone: %s"
    MSG_DRY_RUN_TARGET_DIR_EXISTS="Target directory %s exists"
    MSG_DRY_RUN_TARGET_DIR_NOT_EXISTS="Target directory %s does not exist"
    MSG_DRY_RUN_COPY="Would copy app '%s' to %s"
    MSG_DRY_RUN_COPY_ALL="Would copy all apps to %s"
fi

apps_to_copy=()
custom_base_dir=""
clone_sources=()
dry_run=false

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
        --clone-source)
            if [[ -n "$2" && "$2" != --* ]]; then
                clone_sources+=("$2")
                shift 2
            else
                echo "$MSG_ERR_CLONE_SOURCE_REQUIRE"
                exit 1
            fi
            ;;
        --dry-run)
            dry_run=true
            shift
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
    'https://wget.la/https://github.com'
    'https://ghfast.top/https://github.com'
    'https://githubfast.com'
    'https://ghproxy.net/https://github.com'
)

declare -A mirror_sites=(
    [codeberg]='https://codeberg.org/pooneyy/1Panel-Appstore.git'
    [forgejo]='https://code.forgejo.org/pooneyy/1Panel-Appstore.git'
    [gitea]='https://gitea.com/pooneyy/1Panel-Appstore.git'
)
mirror_names=("${!mirror_sites[@]}")

repo_suffix="/pooneyy/1Panel-Appstore.git"

if [ ${#clone_sources[@]} -eq 0 ]; then
    clone_sources=("all")
fi

declare -A source_map
unique_sources=()
for src in "${clone_sources[@]}"; do
    if [[ -z "${source_map[$src]}" ]]; then
        source_map[$src]=1
        unique_sources+=("$src")
    fi
done

if [[ " ${unique_sources[@]} " =~ " all " ]]; then
    final_sources=("all")
else
    has_mirror=false
    for src in "${unique_sources[@]}"; do
        if [[ "$src" == "mirror" ]]; then
            has_mirror=true
            break
        fi
    done

    if $has_mirror; then
        final_sources=()
        for src in "${unique_sources[@]}"; do
            if [[ "$src" == "mirror" ]] || [[ "$src" == "github" ]]; then
                final_sources+=("$src")
            else
                if [[ -n "${mirror_sites[$src]}" ]]; then
                    :
                else
                    printf "$MSG_ERR_UNKNOWN_SOURCE\n" "$src"
                    exit 1
                fi
            fi
        done
    else
        final_sources=()
        for src in "${unique_sources[@]}"; do
            if [[ "$src" == "github" ]] || [[ "$src" == "mirror" ]]; then
                final_sources+=("$src")
            elif [[ -n "${mirror_sites[$src]}" ]]; then
                final_sources+=("$src")
            else
                printf "$MSG_ERR_UNKNOWN_SOURCE\n" "$src"
                exit 1
            fi
        done
    fi
fi

all_urls=()

shuffle_array() {
    local arr=("$@")
    local len=${#arr[@]}
    for ((i=0; i<len; i++)); do
        j=$((RANDOM % (len - i) + i))
        tmp=${arr[i]}
        arr[i]=${arr[j]}
        arr[j]=$tmp
    done
    echo "${arr[@]}"
}

if [[ " ${final_sources[@]} " =~ " all " ]]; then
    for prefix in "${repo_prefixs[@]}"; do
        all_urls+=("${prefix}${repo_suffix}")
    done
    all_indep_urls=("${mirror_sites[@]}")
    shuffled_indep=($(shuffle_array "${all_indep_urls[@]}"))
    all_urls+=("${shuffled_indep[@]}")
else
    if [[ " ${final_sources[@]} " =~ " github " ]]; then
        for prefix in "${repo_prefixs[@]}"; do
            all_urls+=("${prefix}${repo_suffix}")
        done
    fi

    indep_urls_to_add=()
    for src in "${final_sources[@]}"; do
        if [[ "$src" == "mirror" ]]; then
            indep_urls_to_add=("${mirror_sites[@]}")
            break
        elif [[ -n "${mirror_sites[$src]}" ]]; then
            indep_urls_to_add+=("${mirror_sites[$src]}")
        fi
    done

    if [ ${#indep_urls_to_add[@]} -gt 0 ]; then
        shuffled_indep=($(shuffle_array "${indep_urls_to_add[@]}"))
        all_urls+=("${shuffled_indep[@]}")
    fi
fi

if $dry_run; then
    echo "$MSG_DRY_RUN_MODE"
    echo ""
    echo "$MSG_DRY_RUN_URL_HEADER"
    for url in "${all_urls[@]}"; do
        printf "$MSG_DRY_RUN_URL\n" "$url"
    done
    echo ""
    target_dir="$BASE_DIR/1panel/resource/apps/local/"
    if [ ${#apps_to_copy[@]} -gt 0 ]; then
        for app in "${apps_to_copy[@]}"; do
            printf "$MSG_DRY_RUN_COPY\n" "$app" "$target_dir"
        done
    else
        printf "$MSG_DRY_RUN_COPY_ALL\n" "$target_dir"
    fi
    if [ -d "$target_dir" ]; then
        printf "$MSG_DRY_RUN_TARGET_DIR_EXISTS\n" "$target_dir"
    else
        printf "$MSG_DRY_RUN_TARGET_DIR_NOT_EXISTS\n" "$target_dir"
    fi
    exit 0
fi

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