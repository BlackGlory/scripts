' 找到NTFS文件系统里超出长度限制的路径
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Array.au3>

Local $root = FileSelectFolder("选择需要检查的目录", "")
Local $list = _FileListToArrayRec($root, "*", $FLTAR_FILESFOLDERS, $FLTAR_RECUR)
Local $result = []
For $path In $list
  If StringLen($path) > 260 Then
    _ArrayAdd($result, $path)
  EndIf
Next
_ArrayDisplay($result)
