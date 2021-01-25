#Requires -PSEdition Core
# 重新注册所有 Windows App, 用于修复一些 Windows 10 的bug.

Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
