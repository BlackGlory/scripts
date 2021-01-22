#!/bin/bash
# backup-docker-volumes {container_name} {save_path}

container="$1" # 容器名称
path=$(readlink --canonicalize-missing "$2") # 备份文件保存目录

# 获取该容器所使用的所有volumes(bind mounts没有.Name属性)
volumes=$(docker inspect --format='{{range .Mounts}}{{println .Name}}{{end}}' "$container")

# 将每个卷以tar包的形式保存至path
while IFS= read volume; do
  # 忽略docker inspect println 导致的空白行
  if [[ ! -z "$volume" ]]; then
    # 确保备份文件保存目录存在
    mkdir --parents "$path"

    docker run \
      --rm \
      --volume "$volume":/data \
      --volume "$path":/backup \
      ubuntu tar --absolute-names --create --file /backup/"$volume".tar /data
  fi
done <<< "$volumes"
