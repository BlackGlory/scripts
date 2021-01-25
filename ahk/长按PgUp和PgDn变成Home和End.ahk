#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; 这个脚本是为那些能够自定义两个侧键的鼠标设计的, 要求先把两个侧键映射到PageUp和PageDown.

~PgDn::
  KeyWait PgDn, T0.5
  If ErrorLevel {
    Send {End}
  }
Return

~NumpadPgdn::
  KeyWait NumpadPgdn, T0.5
  If ErrorLevel {
    Send {End}
  }
Return

~PgUp::
  KeyWait PgUp, T0.5
  If ErrorLevel {
    Send {Home}
  }
Return

~NumpadPgup::
  KeyWait NumpadPgup, T0.5
  If ErrorLevel {
    Send {Home}
  }
Return
