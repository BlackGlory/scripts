#!/bin/bash

# 收集脚本目录下的所有目录路径
script_root="$(dirname "${BASH_SOURCE[0]}")"
paths=$(
  find "$script_root" -mindepth 1 -type d -print0 \
| grep --null-data --invert-match '.git' \
| grep --null-data --invert-match 'node_modules' \
| xargs --null readlink --canonicalize \
)
echo $paths

# 创建将路径更新至PATH的脚本, 将脚本保存为 ~/.update-path-for-blackglory-scripts.sh
script=$(sed 's/.*/PATH="$PATH:&"/' <<< "$paths")
loader_filename='.update-paths-for-blackglory-scripts.sh'
echo "$script" | tee "$HOME"/"$loader_filename"

# 设置 .zshrc, 使脚本在打开终端时运行
loader_command='source $HOME/'"$loader_filename"
if ! grep "$loader_command" ~/.zshrc >/dev/null ;then
  echo -e '\n# https://github.com/BlackGlory/scripts' >>~/.zshrc
  echo "$loader_command" >>~/.zshrc
fi
