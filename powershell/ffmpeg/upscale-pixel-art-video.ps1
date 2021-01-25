#Requires -PSEdition Core
# 使用 ffmpeg 按倍数放大像素艺术视频
# upscale-pixel-art-video.ps1 [-filename] <string> [-multiple] <int>
# filename 需要放大的视频文件路径
# multiple 放大倍数(整数)

param (
  [Parameter(Mandatory=$true)]
  [String]
  $filename
, [Parameter(Mandatory=$true)]
  [Int]
  $multiple
)

function Get-File($filename) {
  return Get-Item $filename
}

function Get-Basename($filename) {
  return (Get-File $filename).BaseName
}

function Get-Extension($filename) {
  return (Get-File $filename).Extension
}

function New-OutputFilename($filename, $multiple) {
  return "$(Get-Basename $filename).$($multiple)x$(Get-Extension($filename))"
}

ffmpeg `
  -i $filename `
  -c:a copy `
  -c:v hevc_nvenc `
  -preset:v slow -rc:v vbr -cq:v 25 -qmin:v 25 -qmax:v 25 `
  -vf scale=iw*$($multiple):ih*$($multiple) `
  -sws_flags neighbor `
  (New-OutputFilename $filename $multiple)
