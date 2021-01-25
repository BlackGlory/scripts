#!/bin/bash
# restore-docker-volume-from-tar {volume_name} {tar_filename}

volume="$1" # 卷名称
tar_filename="$2" # tar文件路径
# 检查tar文件是否存在
if [ ! -f "$tar_filename" ]; then
  echo "file $tar_filename does not exist"
  exit 1
fi

filename=$(readlink --canonicalize-missing "$tar_filename") # tar文件的绝对路径
path=$(dirname "$filename") # tar文件的目录路径
base_filename=$(basename "$filename") # tar文件的路径

docker run \
  --rm \
  --volume "$volume":/data \
  --volume "$path":/backup \
  ubuntu tar --absolute-names --extract --file /backup/"$base_filename" /data
