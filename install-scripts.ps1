#Requires -PSEdition Core
# install-scripts.ps1

function Get-UserPath {
  return [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
}

function Get-PathList {
  return (Get-UserPath) -split ';'
}

function Join-PathList($path_list) {
  return $path_list | Join-String -Separator ';'
}

function Get-ScriptRootPath {
  return $PSScriptRoot
}

function Get-ScriptChildrenPathList {
  return Get-ChildItem -Path (Get-ScriptRootPath) -Recurse -Directory `
  | % { $_.FullName } `
  | ? { -Not $_.Contains('.git') }
  | ? { -Not $_.Contains('node_modules') }
  | ? { -Not $_.Contains('helpers') }
}

function Get-ScriptPathList {
  return @() + (Get-ScriptRootPath) + (Get-ScriptChildrenPathList)
}

function Remove-ScriptPaths($path_list) {
  return $path_list | ? { -Not $_.StartsWith((Get-ScriptRootPath)) }
}

function Add-ScriptPaths($path_list) {
  return $path_list + (Get-ScriptPathList)
}

function Set-SessionPath($path) {
  $env:Path += $path
}

function Set-UserPath($path) {
  [Environment]::SetEnvironmentVariable("Path", $path, [EnvironmentVariableTarget]::User)
}

function Set-Path($path) {
  Set-SessionPath $path
  Set-UserPath $path
}

$path_list = Get-PathList
$path_list = Remove-ScriptPaths $path_list # 清除旧记录
$path_list = Add-ScriptPaths $path_list # 添加新记录
Write-Output $path_list # 打印新的 Path 列表
Set-Path (Join-PathList $path_list)
