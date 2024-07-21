#!/bin/bash

usage() {
    echo "使用方法: $0 <検索ディレクトリ> <キーワード> [除外パターン...]"
    echo "例: $0 /path/to/search 'config' node_modules .git *.log"
    exit 1
}

if [ $# -lt 2 ]; then
    usage
fi

search_dir="$1"
keyword="$2"
shift 2

find_cmd="find \"$search_dir\" "
for exclude in "$@"; do
    find_cmd+="-not -path \"*/$exclude/*\" -and -not -name \"$exclude\" "
done
find_cmd+="-type f -name \"*$keyword*\" -print0"

eval $find_cmd | while IFS= read -r -d '' file; do
    echo "file: $file"
    echo "---"
    cat "$file"
    echo "---"
    echo
done

if [ $? -ne 0 ]; then
    echo "指定されたキーワード '$keyword' を含むファイル名が見つかりませんでした。"
fi