#AutoIt3Wrapper_icon=C:\autoit\mylib\auto_mouse\mouse.ico

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <String.au3>
#include <WinAPI.au3>

Opt("TrayMenuMode", 3)

; 全局変数
Global $idNotepad, $idClose1, $input, $start, $timer, $word, $hGUI, $idExit, $label, $input2, $idOpenBtn, $idOpenTray
Global $record_start_flag = False
Global $play_flag = False
Global $arr[2], $tmp_arr[2]
Global $file_handle = -1
Global $loop_count = 0
Global $wait_time_sec = 0
Global $interval_timer = 0
Global $is_waiting = False
Global $move_num = 1
Global $down_type = False

; 64bit/32bit両対応のWindows標準低レベルマウスフック用変数
Global $hMouseHook = 0
Global $hMouseCallback = 0
Global $dll_user32 = DllOpen("user32.dll")

Example()

; --- Windows標準のマウス監視システム ---
Func _MouseHookProc($nCode, $wParam, $lParam)
    If $nCode >= 0 And $record_start_flag Then
        Local $tMSLLHOOKSTRUCT = DllStructCreate("long X;long Y;dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo", $lParam)
        Local $iX = DllStructGetData($tMSLLHOOKSTRUCT, "X")
        Local $iY = DllStructGetData($tMSLLHOOKSTRUCT, "Y")

        Local $time_diff = TimerDiff($timer)
        $timer = TimerInit()

        Switch $wParam
            Case 0x0201 ; WM_LBUTTONDOWN
                $word &= $time_diff & ",left," & $iX & "," & $iY & @CRLF
            Case 0x0202 ; WM_LBUTTONUP
                $word &= $time_diff & ",up,left," & $iX & "," & $iY & @CRLF
            Case 0x0204 ; WM_RBUTTONDOWN
                $word &= $time_diff & ",right," & $iX & "," & $iY & @CRLF
            Case 0x0205 ; WM_RBUTTONUP
                $word &= $time_diff & ",up,right," & $iX & "," & $iY & @CRLF
            Case 0x0200 ; WM_MOUSEMOVE
                If $tmp_arr[0] <> $iX Or $tmp_arr[1] <> $iY Then
                    $word &= $time_diff & "," & $iX & "," & $iY & @CRLF
                    $tmp_arr[0] = $iX
                    $tmp_arr[1] = $iY
                EndIf
        EndSwitch
    EndIf
    Return _WinAPI_CallNextHookEx($hMouseHook, $nCode, $wParam, $lParam)
EndFunc

; --- フック解除関数 ---
Func _ReleaseHook()
    If $hMouseHook <> 0 Then
        _WinAPI_UnhookWindowsHookEx($hMouseHook)
        $hMouseHook = 0
    EndIf
    If $hMouseCallback <> 0 Then
        DllCallbackFree($hMouseCallback)
        $hMouseCallback = 0
    EndIf
EndFunc

; --- 安全な停止処理（リセット） ---
Func Stop2()
    AdlibUnRegister("_PlayExecution")
    _ReleaseHook()

    If $down_type Then
        MouseUp($down_type)
        $down_type = False
    EndIf

    If $file_handle <> -1 Then
        FileClose($file_handle)
        $file_handle = -1
    EndIf

    $record_start_flag = False
    $play_flag = False
    $is_waiting = False

    GUICtrlSetState($idNotepad, $GUI_ENABLE)
    GUICtrlSetState($start, $GUI_ENABLE)
    WinSetTitle($hGUI, "", "午後のマウス")
EndFunc

Func SpecialEvents()
    Stop2()
    DllClose($dll_user32)
    Exit
EndFunc

; --- 再生マクロ実行関数 ---
Func _PlayExecution()
    If _IsPressed("1B", $dll_user32) Then
        Stop2()
        Return
    EndIf

    ; ループ間の待機処理
    If $is_waiting Then
        Local $elapsed = Int(TimerDiff($interval_timer) / 1000)
        Local $remaining = $wait_time_sec - $elapsed
        If $remaining <= 0 Then
            $is_waiting = False
            $file_handle = FileOpen("mouse_data", 0)
            If $file_handle = -1 Then
                Stop2()
                Return
            EndIf
            WinSetTitle($hGUI, "", "＠" & $loop_count & "回 動作中")
        Else
            WinSetTitle($hGUI, "", "＠" & $loop_count & "回 待機(" & $remaining & ")秒")
            Return
        EndIf
    EndIf

    ; データ読み込み
    Local $mouse = FileReadLine($file_handle)
    If @error Then
        FileClose($file_handle)
        $file_handle = -1
        $loop_count -= 1

        If $loop_count > 0 Then
            $wait_time_sec = Int(GUICtrlRead($input2))
            If $wait_time_sec > 0 Then
                $is_waiting = True
                $interval_timer = TimerInit()
                WinSetTitle($hGUI, "", "＠" & $loop_count & "回 待機(" & $wait_time_sec & ")秒")
            Else
                $file_handle = FileOpen("mouse_data", 0)
                WinSetTitle($hGUI, "", "＠" & $loop_count & "回 動作中")
            EndIf
        Else
            Stop2()
        EndIf
        Return
    EndIf

    Local $MouseArr = _StringExplode($mouse, ",")
    Local $iSize = UBound($MouseArr)
    If $iSize < 3 Then Return

    Local $step_delay = Int($MouseArr[0])
    If $step_delay > 0 Then Sleep($step_delay)

    If $iSize >= 4 And ($MouseArr[1] = "left" Or $MouseArr[1] = "right") Then
        MouseMove(Int($MouseArr[2]), Int($MouseArr[3]), $move_num)
        MouseDown($MouseArr[1])
        $down_type = $MouseArr[1]
    ElseIf $iSize >= 5 And $MouseArr[1] = "up" Then
        MouseMove(Int($MouseArr[3]), Int($MouseArr[4]), $move_num)
        MouseUp($MouseArr[2])
        $down_type = False
    ElseIf $iSize = 3 Then
        MouseMove(Int($MouseArr[1]), Int($MouseArr[2]), $move_num)
    EndIf
EndFunc

; --- メインGUI関数 ---
Func Example()
    $hGUI = GUICreate("午後のマウス", 300, 72)
    TraySetIcon(@LocalAppDataDir & "\mouse.ico")
    GUISetIcon(@LocalAppDataDir & "\mouse.ico")
    GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")

    $idNotepad = GUICtrlCreateButton("記録", 0, 0, 55, 25)
    $idClose1 = GUICtrlCreateButton("停止(ESC)", 60, 0, 65, 25)
    $input = GUICtrlCreateInput("1", 130, 0, 50, 20)
    GUICtrlCreateUpdown($input)
    $start = GUICtrlCreateButton("開始", 220, 0, 60, 25)

    $label = GUICtrlCreateLabel("間隔(秒指定)", 0, 30, 75, 20)
    $input2 = GUICtrlCreateInput("0", 80, 25, 50, 20)

    ; === 設定ゾーン ===
    GUICtrlCreateLabel("", 0, 50, 300, 2, 0x10)
    $idOpenBtn = GUICtrlCreateButton("フォルダを開く", 180, 52, 105, 18)

    $idOpenTray = TrayCreateItem("フォルダを開く")
    TrayCreateItem("")
    $idExit = TrayCreateItem("終了")
    GUISetState(@SW_SHOW, $hGUI)

    While 1
        Switch TrayGetMsg()
            Case $idOpenTray
                ShellExecute(@WorkingDir)
            Case $idExit
                Stop2()
                DllClose($dll_user32)
                Exit
        EndSwitch

        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                Stop2()
                DllClose($dll_user32)
                ExitLoop

            Case $idOpenBtn
                ShellExecute(@WorkingDir)

            Case $idNotepad ; 【記録開始】
                Stop2()
                GUICtrlSetState($idNotepad, $GUI_DISABLE)
                GUICtrlSetState($start, $GUI_DISABLE)
                ControlFocus($hGUI, "", $idClose1)

                $word = ""
                $record_start_flag = True
                $timer = TimerInit()

                Local $aPos = MouseGetPos()
                $tmp_arr[0] = $aPos[0]
                $tmp_arr[1] = $aPos[1]

                $hMouseCallback = DllCallbackRegister("_MouseHookProc", "long_ptr", "int;wparam;lparam")
                $hMouseHook = _WinAPI_SetWindowsHookEx(14, DllCallbackGetPtr($hMouseCallback), _WinAPI_GetModuleHandle(0))

                WinSetTitle($hGUI, "", "記録中... [ESC]で保存")

            Case $idClose1 ; 【停止】
                If $record_start_flag Then
                    $file_handle = FileOpen("mouse_data", 2)
                    FileWrite($file_handle, $word)
                EndIf
                Stop2()

            Case $start ; 【再生開始】
                Stop2()
                GUICtrlSetState($idNotepad, $GUI_DISABLE)
                GUICtrlSetState($start, $GUI_DISABLE)
                ControlFocus($hGUI, "", $idClose1)

                $loop_count = Int(GUICtrlRead($input))
                If $loop_count <= 0 Then $loop_count = 1
                $move_num = 1
                $is_waiting = False

                $file_handle = FileOpen("mouse_data", 0)
                If $file_handle = -1 Then
                    MsgBox(16, "エラー", "mouse_data が見つかりません。先に記録してください。")
                    Stop2()
                    ContinueLoop
                EndIf

                WinSetTitle($hGUI, "", "＠" & $loop_count & "回 動作中")
                $play_flag = True

                AdlibRegister("_PlayExecution", 10)
        EndSwitch

        If $record_start_flag And _IsPressed("1B", $dll_user32) Then
            $file_handle = FileOpen("mouse_data", 2)
            FileWrite($file_handle, $word)
            Stop2()
        EndIf

        Sleep(10)
    WEnd ; 👈 【ここを修正！】EndWhileからWEndに変更しました。

    GUIDelete($hGUI)
    DllClose($dll_user32)
EndFunc   ;==>Example