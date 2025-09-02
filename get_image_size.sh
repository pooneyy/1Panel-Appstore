#!/bin/bash

ARCH=""
MANIFEST_FILE="manifest.json"

while [[ $# -gt 0 ]]; do
    case $1 in
        --arch)
            ARCH="$2"
            shift 2
            ;;
    esac
done

MANIFEST_CONTENT=$(cat "$MANIFEST_FILE")

if echo "$MANIFEST_CONTENT" | jq -e '.[0]' > /dev/null 2>&1; then
    MANIFEST_ARRAY=$(echo "$MANIFEST_CONTENT" | jq -c '.[]')
else
    MANIFEST_ARRAY=$(echo "$MANIFEST_CONTENT" | jq -c '.')
fi

arch_info=""

while IFS= read -r item; do
    if [ -n "$item" ]; then
        item_arch=$(echo "$item" | jq -r '.Descriptor.platform.architecture // empty')
        item_variant=$(echo "$item" | jq -r '.Descriptor.platform.variant // empty')
        
        if [[ "$ARCH" == *"$item_arch"* ]]; then
            if [ -n "$VARIANT_PART" ]; then
                if [ "$item_variant" = "$VARIANT_PART" ]; then
                    arch_info="$item"
                    break
                fi
            else
                arch_info="$item"
                break
            fi
        fi
    fi
done <<< "$MANIFEST_ARRAY"

if [ -z "$arch_info" ]; then
    echo "Error: No manifest found for architecture $ARCH"
    exit 1
fi

total_size=0
layers=$(echo "$arch_info" | jq -c '.OCIManifest.layers[]')

if [ -z "$layers" ]; then
    echo "Error: No layers found in the manifest"
    exit 1
fi

while IFS= read -r layer; do
    if [ -n "$layer" ]; then
        size=$(echo "$layer" | jq -r '.size')
        total_size=$((total_size + size))
    fi
done <<< "$layers"

echo "$((total_size / 1024 / 1024)) MB"
