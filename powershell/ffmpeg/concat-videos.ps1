#Requires -PSEdition Core
# 用 ffmpeg 拼接具有相同编码的视频文件
# concat-videos.ps1 [-output] <string> [-filenames] <string[]> [<CommonParameters>]
# output 输出文件路径
# filenames 需要连接的文件路径列表, 按先后顺序连接
# 例子 concat-videos.ps1 output.mp4 (ls ./*.mp4)

param (
  [Parameter(Mandatory=$true)]
  [String]
  $output = $(throw "output parameter is required.")
, [Parameter(
    Mandatory=$true
  , ValueFromRemainingArguments=$true
  )]
  [String[]]
  $filenames = $(throw "filenames parameter is required.")
)

function New-List($filenames) {
  $tmp = New-TemporaryFile
  foreach ($filename in $filenames) {
    "file '" + $filename + "'" >> $tmp
  }
  return $tmp
}

function Remove-List($filename) {
  Remove-Item $filename
}

function Start-Concat($list, $output) {
  ffmpeg `
    -f concat `
    -safe 0 `
    -i $list `
    -c copy `
    $output
}

$list = New-List $filenames
Start-Concat $list $output
Remove-List $list
