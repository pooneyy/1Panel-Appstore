#!/bin/bash
# This script copies the version from docker-compose.yml to config.json.

app_name=$1
old_version=$2

# find all docker-compose files under apps/$app_name (there should be only one)
docker_compose_files=$(find apps/$app_name/$old_version -name docker-compose.yml)

for docker_compose_file in $docker_compose_files
do
    # Assuming that the app version will be from the first docker image
    first_service=$(yq '.services | keys | .[0]' $docker_compose_file)
    echo "第一个服务是: $first_service"

    image=$(yq .services.$first_service.image $docker_compose_file)
    echo "该服务的镜像: $image"

    # Only apply changes if the format is <image>:<version>
    if [[ "$image" == *":"* ]]; then
        version=$(cut -d ":" -f2- <<< "$image")
        echo "版本号: $version"

        # Trim the "v" prefix
        trimmed_version=${version/#"v"}
        echo "Trimmed version: $trimmed_version"
        if [ "$old_version" != "$trimmed_version" ]; then
            echo "将 apps/$app_name/$old_version 重命名为 apps/$app_name/$trimmed_version"
            if [ ! -d "apps/$app_name/$trimmed_version" ]; then
                mv apps/$app_name/$old_version apps/$app_name/$trimmed_version
                echo "$trimmed_version" > apps/$app_name/${old_version}.version
            else
                echo "apps/$app_name/$trimmed_version 文件夹已存在"
                exit 1
            fi
        fi
    fi
done