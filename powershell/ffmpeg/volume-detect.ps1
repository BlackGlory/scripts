#Requires -PSEdition Core
# 使用 ffmpeg 检测视频音量
# volume-detect.ps1 [-filename] <string>
# filename 视频文件路径

param (
  [Parameter(Mandatory=$true)]
  [String]
  $filename = $(throw "filename parameter is required.")
)

ffmpeg `
  -i $filename `
  -filter:a volumedetect `
  -vn -sn -dn `
  -f null NUL
