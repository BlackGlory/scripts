#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; 这个脚本是为那些不能够自定义鼠标侧键, 却有两个鼠标侧键的鼠标设计的

XButton1::
  Send {PgDn}
  Sleep 200
  times := 0
  While GetKeyState("XButton1", "P") {
    If (times++ < 1) {
      Send {PgDn}
      Sleep 200
    } Else {
      Send {End}
      Break
    }
  }
Return
XButton1 Up::times:=0

XButton2::
  Send {PgUp}
  Sleep 200
  times := 0
  While GetKeyState("XButton2", "P") {
    If (times++ < 1) {
      Send {PgUp}
      Sleep 200
    } Else {
      Send {Home}
      Break
    }
  }
Return
XButton2 Up::times:=0
