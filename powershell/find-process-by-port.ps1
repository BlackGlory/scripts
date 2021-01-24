#Requires -PSEdition Core
# 查找占用端口的进程
# find-process-by-port.ps1 [-port] <int>
# port 需要查询的端口号

param (
  [Parameter(Mandatory=$true)]
  [Int]
  $port = $(throw "port parameter is required.")
)

function Get-ProcessByPid($pids) {
  return Get-Process -Id $pids
}

function Find-ProcessByLocalPort($port) {
  return (Get-NetTCPConnection -LocalPort $port).OwningProcess | Select-Object -Unique
}

Write-Output (Get-ProcessByPid (Find-ProcessByLocalPort $port))
