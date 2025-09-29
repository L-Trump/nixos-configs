#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash skopeo coreutils jq

cd "${0%/*}" || exit

NIX_FILE="../vars/containers.nix"

get_latest_digest() {
    local image_url=$1
    local latest_tag=${2:-"latest"}  # 如果未提供 latest_tag，则默认为 "latest"

    LATEST_DIGEST=$(skopeo inspect "docker://$image_url:$latest_tag" --format "{{.Digest}}" 2>/dev/null)
    if [ -z "$LATEST_DIGEST" ]; then
        echo "无法获取 $latest_tag 标签的 digest，请检查镜像地址是否正确：$image_url"
        return 1
    fi

    echo "$LATEST_DIGEST"
    return 0
}

# 函数：获取镜像的最新 tag
get_latest_version() {
    local image_url=$1
    local latest_tag=${2:-"latest"}  # 如果未提供 latest_tag，则默认为 "latest"

    # 获取 latest_tag 标签的 digest
    LATEST_DIGEST=$(skopeo inspect "docker://$image_url:$latest_tag" --format "{{.Digest}}" 2>/dev/null)
    if [ -z "$LATEST_DIGEST" ]; then
        echo "无法获取 $latest_tag 标签的 digest，请检查镜像地址是否正确：$image_url"
        return 1
    fi

    # 获取所有标签并倒序排序
    TAGS=$(skopeo list-tags "docker://$image_url" | jq -r '.Tags[]' | sort -V -r)

    # 筛选与 latest_tag digest 相同的标签，并排除 latest_tag 和不包含数字的标签
    for TAG in $TAGS; do
        if ! [[ "$TAG" =~ [0-9] ]]; then
            continue
        fi
        DIGEST=$(skopeo inspect "docker://$image_url:$TAG" --format "{{.Digest}}" 2>/dev/null)
        if [ "$DIGEST" == "$LATEST_DIGEST" ]; then
            echo "$TAG"
            return 0
        fi
    done

    # 如果没有找到符合条件的标签
    echo "$TAGS"
    echo "未找到与 $latest_tag 指向相同 digest 的版本"
    return 1
}

# 函数：更新 Nix 文件中的所有镜像版本
update_nix_file() {
    local nix_file=$1
    # 使用 nix-instantiate 提取 Nix 文件内容并转换为 JSON
    nix_json=$(nix-instantiate --eval -E "import $nix_file {}" --strict --json)

    # 解析 JSON 并更新每个镜像的版本
    entries=$(echo "$nix_json" | jq -c 'to_entries[]')

    while read -r entry; do
        index=$(echo "$entry" | jq -r '.key')
        image=$(echo "$entry" | jq -r '.value.image')
        current_tag=$(echo "$entry" | jq -r '.value.tag')
        current_digest=$(echo "$entry" | jq -r '.value.digest')
        latest_tag=$(echo "$entry" | jq -r '.value.latestTag // "latest"')

        echo "开始更新 $image"

        latest_digest=$(get_latest_digest "$image" "$latest_tag")

        if [ $? -ne 0 ]; then
            echo "$latest_digest"
            echo "更新镜像 $image 失败"
            continue
        fi

        if [ "$current_digest" = "$latest_digest" ]; then
            echo "$image 的 digest 未发生变化，跳过更新"
            continue
        fi

        echo "$index: $current_digest -> $latest_digest"
        sed -i "/$index = {/,/}/ s|digest = \".*\";|digest = \"$latest_digest\";|" "$nix_file"

        # # 调用函数获取最新 tag
        # latest_version=$(get_latest_version "$image" "$latest_tag")

        # if [ $? -ne 0 ]; then
        #     echo "$latest_version"
        #     echo "更新镜像 $image 失败"
        #     continue
        # fi

        # echo "$index: $current_tag -> $latest_version"

        # # 使用 sed 更新 Nix 文件中的 tag
        # sed -i "/$index = {/,/}/ s|tag = \".*\";|tag = \"$latest_version\";|" "$nix_file"
        # echo "已更新镜像 $image 的 tag 为 $latest_version"
    done <<< "$entries"
}

# 主逻辑
update_nix_file "$NIX_FILE"
