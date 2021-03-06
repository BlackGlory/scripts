#!/bin/bash
# backup-all-docker-volumes {save_path}

path=$(readlink --canonicalize-missing "$1") # 备份文件保存目录

# 获取所有容器名
containers=$(docker ps --format '{{.Names}}')

# 为每个容器调用backup-docker-volumes.sh
while IFS= read container; do
  # ./backup-docker-volumes.sh
  backup-docker-volumes "$container" "$path/$container"
done <<< "$containers"
