#Requires -PSEdition Core
# 使用 ffmpeg 将 flv 文件转换为 mp4, 在同目录下以 mp4 扩展名保存
# convert-flv-to-mp4.ps1 [-filename] <string> [[-title] <string>]
# filename 源文件路径, 通常为扩展名为 flv 的文件
# title 输出文件名的前缀, 可以省略

if ($PSVersionTable.PSVersion -lt "6.0") {
	pwsh -f $SCRIPT:MyInvocation.MyCommand.Path
	return
}

param (
  [Parameter(Mandatory=$true)]
  [String]
  $filename = $(throw "filename parameter is required.")
, [String]
  $title
)

function New-Filename($basename, $extension = '', $title = '') {
  $result = $basename + $extension
  if ($title) {
    $result = $title+ ' ' + $result
  }
  return $result
}

function Get-File($filename) {
  return Get-Item $filename
}

function Get-Basename($filename) {
  return (Get-File $filename).BaseName
}

function Get-Directory($filename) {
  return (Get-File $filename).Directory
}

function Get-Extension($filename) {
  return (Get-File $filename).Extension
}

$basename = Get-Basename $filename
$new_filename = New-Filename $basename '.mp4' $title
$directory = Get-Directory $filename
$output = Join-Path $directory $new_filename

ffmpeg `
  -i $filename `
  -c copy `
  -f mp4 $output
