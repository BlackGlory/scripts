#Requires -PSEdition Core
# 使用 ffmpeg 从视频里剪辑出片段
# cut-video.ps1 [-filename] <string> [-start] <string> [-end] <string> [-speed]
# 例子
# cut-video.ps1 test.mp4 00:10:00.000 00:20:00.000
# cut-video.ps1 test.mp4 00:10:00.000 00:20:00.000 -speed

param (
  [Parameter(Mandatory=$true)]
  [String]
  $filename = $(throw "filename parameter is required.")
, [Parameter(Mandatory=$true)]
  [String]
  $start = $(throw "start parameter is required.")
, [Parameter(Mandatory=$true)]
  [String]
  $end = $(throw "end parameter is required.")
, [Switch]
  $speed = $false
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

function Get-Extension($filename) {
  return (Get-File $filename).Extension
}

function New-ClipFilename($filename, $start, $end) {
  return Join-Path `
    (Get-Directory $filename) `
    ((Get-Basename $filename) + '.clip' + (Get-Extension $filename))
}

function Get-SpeedClip($filename, $start, $end) {
  # 直接剪辑(性能很好, 但不能得到精确的剪辑结果)
  ffmpeg `
  -ss $start -to $end `
  -i $filename `
  -c copy `
  (New-ClipFilename $filename $start $end)
}

function Get-QualityClip($filename, $start, $end) {
  # 先分析整个视频文件(性能很差), 然后剪辑(可以得到精确的剪辑结果)
  ffmpeg `
  -i $filename `
  -ss $start -to $end `
  -c copy `
  (New-ClipFilename $filename $start $end)
}

if ($speed) {
  Get-SpeedClip $filename $start $end
} else {
  Get-QualityClip $filename $start $end
}
