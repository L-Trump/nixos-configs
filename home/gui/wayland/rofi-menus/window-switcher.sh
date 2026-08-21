#!/usr/bin/env bash

set -uo pipefail

THEME="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/rofi-menus/rofi/launcher.rasi"

show_error() {
    local message=$1
    if command -v rofi >/dev/null 2>&1; then
        rofi -no-config -theme "$THEME" -e "$message" >/dev/null 2>&1 || true
    else
        printf 'niri-window-switcher: %s\n' "$message" >&2
    fi
}

for command_name in niri jq rofi; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        show_error "缺少依赖：$command_name"
        exit 1
    fi
done

if ! windows_json=$(niri msg --json windows 2>/dev/null); then
    show_error "无法从 niri 获取窗口列表"
    exit 1
fi

if ! workspaces_json=$(niri msg --json workspaces 2>/dev/null); then
    show_error "无法从 niri 获取 workspace 列表"
    exit 1
fi

if ! rows=$(
    jq -r --argjson workspaces "$workspaces_json" '
        def clean:
            tostring
            | gsub("[\t\r\n\u001f]"; " ")
            | gsub("  +"; " ");
        def text_or($fallback):
            (. // "")
            | if length == 0 then $fallback else . end
            | clean;

        ($workspaces
            | map({ key: (.id | tostring), value: . })
            | from_entries) as $workspace_by_id
        | sort_by(.focus_timestamp.secs // 0, .focus_timestamp.nanos // 0)
        | reverse
        | .[]
        | ($workspace_by_id[(.workspace_id | tostring)] // {}) as $workspace
        | [
            (.id | tostring),
            (.title | text_or("无标题")),
            (.app_id | text_or("unknown")),
            (
                (($workspace.output // "?") | clean)
                + ":"
                + (($workspace.name // $workspace.idx // "?") | clean)
            )
        ]
        | join("\u001f")
    ' <<<"$windows_json"
); then
    show_error "无法解析 niri 窗口列表"
    exit 1
fi

ids=()
labels=()
icons=()

while IFS=$'\x1f' read -r id title app_id workspace; do
    [[ -n $id ]] || continue
    ids+=("$id")
    labels+=("[$workspace]  $title  —  $app_id")
    icons+=("$app_id")
done <<<"$rows"

if ((${#ids[@]} == 0)); then
    show_error "当前没有可切换的窗口"
    exit 0
fi

colors=(
    '#EC7875' '#EC6798' '#BE78D1' '#75A4CD' '#00C7DF' '#00B19F' '#61C766'
    '#B9C244' '#EBD369' '#EDB83F' '#E57C46' '#AC8476' '#6C77BB' '#6D8895'
)
accent=${colors[RANDOM % ${#colors[@]}]}

if ! selected_index=$(
    for index in "${!labels[@]}"; do
        printf '%s\0icon\x1f%s\n' "${labels[index]}" "${icons[index]}"
    done | rofi \
        -no-config \
        -no-lazy-grab \
        -dpi 144 \
        -dmenu \
        -i \
        -no-custom \
        -show-icons \
        -format i \
        -p '窗口' \
        -theme "$THEME" \
        -theme-str "* { ac: ${accent}FF; se: ${accent}40; } window { width: 1050px; } listview { columns: 1; lines: 12; }"
); then
    exit 0
fi

[[ $selected_index =~ ^[0-9]+$ ]] || exit 1
((selected_index < ${#ids[@]})) || exit 1

if ! niri msg action focus-window --id "${ids[selected_index]}" >/dev/null; then
    show_error "窗口可能已关闭，无法切换"
    exit 1
fi
