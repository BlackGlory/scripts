#Requires -PSEdition Core
# 使用 ffmpeg-normalize 对文件进行响度标准化, 用于将音量很小的视频文件调整至正常音量
# normalize-video.ps1 [-filename] <string>
# filename 源文件路径, 输出文件会在扩展名前加上".normalize"

param (
  [Parameter(Mandatory=$true)]
  [String]
  $filename = $(throw "filename parameter is required.")
)

function Get-File($filename) {
  return Get-Item $filename
}

function Get-Extension($filename) {
  return (Get-File $filename).Extension
}

function Get-Basename($filename) {
  return (Get-File $filename).BaseName
}

function Get-Directory($filename) {
  return (Get-File $filename).Directory
}

function New-Filename($filename) {
  $extension = Get-Extension $filename
  $basename = Get-Basename $filename
  return  $basename + '.normalize' + $extension
}

$output = Join-Path (Get-Directory $filename) (New-Filename $filename)

ffmpeg-normalize $filename `
  --normalization-type peak --target-level 0 `
  --audio-codec aac `
  --output $output
