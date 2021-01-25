# 用 ffmpeg 的 NVENC 的 CQ 参数压制 HEVC 视频
# hevc-encode.ps1 [-filename] <string> [-cq] <int>
# filename 需要转码的视频文件
# cq NVENC 的 CQ 值, 默认为 25

param (
  [Parameter(
    Mandatory=$true
  , ValueFromRemainingArguments=$true
  )]
  [String]
  $filename
, [Parameter(Mandatory=$true)]
  [Int]
  $cq = 25
)

function Get-File($filename) {
  return Get-Item $filename
}

function Get-Directory($filename) {
  return (Get-File $filename).Directory
}

function Get-Basename($filename) {
  return (Get-File $filename).BaseName
}

function New-EncodedFilename($filename) {
  return (Get-Basename $filename) + '.encoded.mp4'
}

function New-OutputFilename($filename) {
  return Join-Path `
    (Get-Directory $filename) `
    (New-EncodedFilename $filename)
}

function Start-Encode($cq, $filename) {
  ffmpeg `
  -i $filename `
  -c:a copy `
  -c:v hevc_nvenc `
  -preset:v slow -rc:v vbr -cq:v $cq -qmin:v $cq -qmax:v $cq `
  -f mp4 (New-OutputFilename $filename)
}

Start-Encode $cq $filename
