#Requires -PSEdition Core
# 使用 ffmpeg 从视频文件中提取出加速/减速后的音频文件
# extract-audio.ps1 [-filename] <string> [-speed] <float>
# filename 需要提取的视频文件路径
# speed 加速倍数, 取值范围为0.5到4.0, 精确到小数点后1位, 默认为 1.0

param (
  [Parameter(Mandatory=$true)]
  [String]
  $filename
, [Parameter(Mandatory=$true)]
  [ValidateRange(0.5, 4.0)]
  [Float]
  $speed = 1.0
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

function New-ExtractFilename($filename) {
  return "$(Get-Basename $filename).aac"
}

function New-OutputFilename($filename) {
  return Join-Path `
    (Get-Directory $filename) `
    (New-ExtractFilename $filename)
}

function New-AtempoFilter($speed) {
  if ($speed -le 2.0) {
    return "atempo=$speed"
  }
  $arr = @('atempo=2.0')
  while ($true) {
    $speed = $speed / 2.0
    if ($speed -le 2.0) {
      $arr += "atempo=$speed"
      break
    } else {
      $arr += 'atempo=2.0'
    }
  }
  return $arr -join ','
}

function Start-Extract($speed, $filename) {
  Write-Output (New-AtempoFilter $speed)
  ffmpeg `
    -i $filename `
    -filter:a (New-AtempoFilter $speed) `
    -vn `
    (New-OutputFilename $filename 'aac')
}

Start-Extract $speed $filename
