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

# 参数解析
apps_to_copy=()
custom_base_dir=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --app)
            if [[ -n "$2" && "$2" != --* ]]; then
                apps_to_copy+=("$2")
                shift 2
            else
                echo "Error: --app parameter requires an app name"
                exit 1
            fi
            ;;
        --1panel-path)
            if [[ -n "$2" && "$2" != --* ]]; then
                if [[ -n "$custom_base_dir" ]]; then
                    echo "Error: Only one --1panel-path parameter can be specified"
                    exit 1
                fi
                custom_base_dir="$2"
                shift 2
            else
                echo "Error: --1Panel-path parameter requires a path"
                exit 1
            fi
            ;;
        *)
            echo "Note: Unknown parameter $1 ignored"
            shift
            ;;
    esac
done

echo " ###########################################"
echo " #                 Note                    #"
echo " # If you want to copy specific apps, use  #"
echo " # --app <app_name> parameter              #"
echo " #                                         #"
echo " # If you want to specify the installation #"
echo " # path of 1Panel, use the                 #"
echo " # --1panel-path <path> parameter          #"
echo " #                                         #"
echo " # For example, if you 1panel is installed #"
echo " # in /opt, use:                           #"
echo " # bash update_local_appstore.sh \\         #"
echo " #   --app app_name_1 \\                    #"
echo " #   --app app_name_2 \\                    #"
echo " #   --1panel-path /opt                    #"
echo " ###########################################"

if [[ -n "$custom_base_dir" ]]; then
    BASE_DIR="$custom_base_dir"
else
    BASE_DIR=$(which 1pctl | xargs grep '^BASE_DIR=' | cut -d'=' -f2)
    if [ -z "$BASE_DIR" ]; then
        echo "No installation path found for 1panel"
        exit 1
    fi
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
counter=0
for repo_prefix in "${repo_prefixs[@]}"; do
    full_url="${repo_prefix}${repo_suffix}"
    git clone --depth 1 -b localApps $full_url $TEMP_DIR > /dev/null 2>&1 && break
    counter=$((counter + 1))
done
if [ $counter -eq ${#repo_prefixs[@]} ]; then
    echo "All sources have been attempted, but cloning Failed"
else
    echo "Successfully cloned from source ${full_url}"
    echo "Latest commit in the local repository:"
    git -C $TEMP_DIR log --pretty=format:"%s - %h - %cr(%ci)" -n 1
    
    if [ ${#apps_to_copy[@]} -gt 0 ]; then
        echo ""
        echo "Only copy: ${apps_to_copy[*]}"
        for app in "${apps_to_copy[@]}"; do
            if [ -d "$TEMP_DIR/apps/$app" ]; then
                cp -rf "$TEMP_DIR/apps/$app" "$BASE_DIR/1panel/resource/apps/local/"
                echo "Copied success: $app"
            else
                echo "WARNING: App '$app' does not exist in repository"
            fi
        done
    else
        cp -rf $TEMP_DIR/apps/* $BASE_DIR/1panel/resource/apps/local/
    fi
    
    rm -rf $TEMP_DIR
fi