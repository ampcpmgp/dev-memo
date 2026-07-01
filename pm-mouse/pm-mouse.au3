#AutoIt3Wrapper_icon=C:\autoit\mylib\auto_mouse\mouse.ico

#include <GuiComboBox.au3>
#include <GuiListView.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <String.au3>
#include <WinAPI.au3>

Opt("TrayMenuMode", 3)

; 全局変数
Global $idNotepad, $idClose1, $input, $start, $timer, $word, $hGUI, $idExit, $label, $input2, $idOpenBtn, $idOpenTray, $idFileCombo, $idRestoreBtn, $idRestoreTray, $idNewBtn, $idEditBtn, $idDelBtn
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
Global $last_activity_timer = 0 ; 無操作検出用タイマー

; 64bit/32bit両対応のWindows標準低レベルマウスフック用変数
Global $hMouseHook = 0
Global $hMouseCallback = 0
Global $dll_user32 = DllOpen("user32.dll")

; ★★★ 複合シーケンス用 追加変数 ★★★
Global $series_commands[100]        ; ファイル名（フルパス）配列
Global $series_count = 0            ; 登録ファイル数
Global $series_idx = 0              ; 実行中インデックス
Global $series_is_playing = False   ; 複合再生中フラグ
Global $series_current_file = ""    ; 現在のシーケンスファイル名
; シーケンスセクションGUIコントロールID
Global $idSecSeqLabel, $idSecSep
Global $idSeqClose, $idSeqInput, $idSeqStart, $idSeqInput2
Global $idSeriesFileLabel, $idSeriesFileCombo
Global $idSeriesNewBtn, $idSeriesRenameBtn, $idSeriesFileDelBtn
Global $idSeriesAdd, $idSeriesUp, $idSeriesDown, $idSeriesItemDel
Global $idSeriesList, $idSeriesSave

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
                $last_activity_timer = TimerInit()
            Case 0x0202 ; WM_LBUTTONUP
                $word &= $time_diff & ",up,left," & $iX & "," & $iY & @CRLF
                $last_activity_timer = TimerInit()
            Case 0x0204 ; WM_RBUTTONDOWN
                $word &= $time_diff & ",right," & $iX & "," & $iY & @CRLF
                $last_activity_timer = TimerInit()
            Case 0x0205 ; WM_RBUTTONUP
                $word &= $time_diff & ",up,right," & $iX & "," & $iY & @CRLF
                $last_activity_timer = TimerInit()
            Case 0x0200 ; WM_MOUSEMOVE
                If $tmp_arr[0] <> $iX Or $tmp_arr[1] <> $iY Then
                    $word &= $time_diff & "," & $iX & "," & $iY & @CRLF
                    $tmp_arr[0] = $iX
                    $tmp_arr[1] = $iY
                    $last_activity_timer = TimerInit()
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
    AdlibUnRegister("_PlayExecutionSeries")
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
    $series_is_playing = False
    $series_idx = 0
    _ClearSeriesSelection()

    GUICtrlSetState($idNotepad, $GUI_ENABLE)
    GUICtrlSetState($start, $GUI_ENABLE)
    WinSetTitle($hGUI, "", "午後のマウス")
EndFunc

Func SpecialEvents()
    Stop2()
    DllClose($dll_user32)
    Exit
EndFunc

; --- 再生のみ停止（ESC用／ファイルや録音には触らない） ---
Func _StopPlay()
    AdlibUnRegister("_PlayExecution")
    AdlibUnRegister("_PlayExecutionSeries")
    If $down_type Then
        MouseUp($down_type)
        $down_type = False
    EndIf
    If $file_handle <> -1 Then
        FileClose($file_handle)
        $file_handle = -1
    EndIf
    $play_flag = False
    $is_waiting = False
    $series_is_playing = False
    $series_idx = 0
    _ClearSeriesSelection()
    GUICtrlSetState($idNotepad, $GUI_ENABLE)
    GUICtrlSetState($start, $GUI_ENABLE)
    WinSetTitle($hGUI, "", "午後のマウス")
EndFunc

; ============================================================================
; ★★★ 1行実行関数（共通） ★★★
; ============================================================================
Func _ExecuteLine($sLine)
    Local $MouseArr = _StringExplode($sLine, ",")
    Local $iSize = UBound($MouseArr)
    If $iSize < 2 Then Return

    Local $step_delay = Int($MouseArr[0])
    If $step_delay > 0 Then Sleep($step_delay)

    If $iSize >= 2 And $MouseArr[1] = "wait" Then Return
    If $iSize < 3 Then Return

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

; --- 再生マクロ実行関数（単一ファイル） ---
Func _PlayExecution()
    If _IsPressed("1B", $dll_user32) Then
        _StopPlay()
        Return
    EndIf

    If $is_waiting Then
        Local $elapsed = Int(TimerDiff($interval_timer) / 1000)
        Local $remaining = $wait_time_sec - $elapsed
        If $remaining <= 0 Then
            $is_waiting = False
            $file_handle = FileOpen(_GetFileListSel(), 0)
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
                $file_handle = FileOpen(_GetFileListSel(), 0)
                WinSetTitle($hGUI, "", "＠" & $loop_count & "回 動作中")
            EndIf
        Else
            Stop2()
        EndIf
        Return
    EndIf

    _ExecuteLine($mouse)
EndFunc

; ============================================================================
; ★★★ 複合シーケンス実行エンジン ★★★
; ============================================================================
Func _PlayExecutionSeries()
    If _IsPressed("1B", $dll_user32) Then
        _StopPlay()
        Return
    EndIf

    If $file_handle <> -1 Then
        Local $mouse = FileReadLine($file_handle)
        If @error Then
            FileClose($file_handle)
            $file_handle = -1
            $series_idx += 1
            If $series_idx >= $series_count Then
                $loop_count -= 1
                If $loop_count > 0 Then
                    $series_idx = 0
                    _OpenSeriesFile(0)
                Else
                    Stop2()
                EndIf
            Else
                _OpenSeriesFile($series_idx)
            EndIf
            Return
        EndIf
        _ExecuteLine($mouse)
    EndIf
EndFunc

Func _OpenSeriesFile($iIdx)
    Local $sPath = $series_commands[$iIdx]
    $file_handle = FileOpen($sPath, 0)
    If $file_handle = -1 Then
        MsgBox(16, "エラー", $sPath & " が見つかりません。")
        Stop2()
        Return
    EndIf
    Local $sName = $sPath
    Local $p = StringInStr($sName, "\", 0, -1)
    If $p > 0 Then $sName = StringMid($sName, $p + 1)
    WinSetTitle($hGUI, "", "＠" & $loop_count & "回 " & $iIdx + 1 & "/" & $series_count & " " & $sName)
    ; 実行中の行をリストで選択表示
    _SelectSeriesItem($iIdx)
EndFunc

; --- メインGUI関数 ---
Func Example()
    $hGUI = GUICreate("午後のマウス", 350, 605)
    TraySetIcon(@LocalAppDataDir & "\mouse.ico")
    GUISetIcon(@LocalAppDataDir & "\mouse.ico")
    GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")

    ; ==========================================================================
    ; ◆ 単体ファイル実行 セクション
    ; ==========================================================================
    ; セクション見出し
    GUICtrlCreateLabel("── 単体 ──", 5, 3, 85, 15)
    GUICtrlSetFont(-1, 9, 800)

    ; 操作行
    $idNotepad = GUICtrlCreateButton("記録", 5, 20, 45, 22)
    $idClose1 = GUICtrlCreateButton("停止(ESC)", 53, 20, 65, 22)
    $input = GUICtrlCreateInput("1", 143, 20, 40, 20)
    GUICtrlCreateUpdown($input)
    $start = GUICtrlCreateButton("開始", 187, 20, 50, 22)

    ; 間隔行
    $label = GUICtrlCreateLabel("間隔(秒指定)", 5, 46, 75, 20)
    $input2 = GUICtrlCreateInput("0", 85, 44, 40, 20)

    ; ファイル行
    GUICtrlCreateLabel("ファイル", 7, 69, 36, 15)
    $idFileCombo = GUICtrlCreateListView("ファイル", 45, 66, 290, 162, 0x00010008)
    _GUICtrlListView_SetColumnWidth($idFileCombo, 0, 274)

    ; 管理ボタン行
    $idNewBtn = GUICtrlCreateButton("新規", 5, 232, 40, 20)
    $idEditBtn = GUICtrlCreateButton("編集", 48, 232, 40, 20)
    $idDelBtn = GUICtrlCreateButton("削除", 91, 232, 40, 20)
    $idRestoreBtn = GUICtrlCreateButton("戻す", 155, 232, 55, 20)
    $idOpenBtn = GUICtrlCreateButton("フォルダ", 225, 232, 105, 20)

    ; セクション区切り
    GUICtrlCreateLabel("", 0, 256, 350, 2, 0x10)

    ; ==========================================================================
    ; ◆ シーケンスファイル実行 セクション
    ; ==========================================================================
    ; セクション見出し
    GUICtrlCreateLabel("── シーケンス ──", 5, 261, 100, 15)
    GUICtrlSetFont(-1, 9, 800)

    ; 操作行
    $idSeqClose = GUICtrlCreateButton("停止(ESC)", 5, 278, 65, 22)
    $idSeqInput = GUICtrlCreateInput("1", 143, 278, 40, 20)
    GUICtrlCreateUpdown($idSeqInput)
    $idSeqStart = GUICtrlCreateButton("開始", 187, 278, 50, 22)

    ; 間隔行
    GUICtrlCreateLabel("間隔(秒指定)", 5, 304, 75, 20)
    $idSeqInput2 = GUICtrlCreateInput("0", 85, 302, 40, 20)

    ; ファイル行
    GUICtrlCreateLabel("Seq:", 7, 328, 30, 20)
    $idSeriesFileCombo = GUICtrlCreateCombo("", 39, 325, 150, 20)
    $idSeriesNewBtn = GUICtrlCreateButton("新規", 193, 325, 40, 22)
    $idSeriesRenameBtn = GUICtrlCreateButton("編集", 235, 325, 40, 22)
    $idSeriesFileDelBtn = GUICtrlCreateButton("削除", 277, 325, 40, 22)

    ; 編集ボタン行
    $idSeriesAdd = GUICtrlCreateButton("追加", 5, 351, 40, 22)
    $idSeriesUp = GUICtrlCreateButton("↑", 48, 351, 30, 22)
    $idSeriesDown = GUICtrlCreateButton("↓", 80, 351, 30, 22)
    $idSeriesItemDel = GUICtrlCreateButton("削除", 113, 351, 40, 22)
    $idSeriesSave = GUICtrlCreateButton("保存", 200, 351, 55, 22)

    ; シーケンスリスト
    $idSeriesList = GUICtrlCreateListView("項目", 5, 377, 330, 215, 0x00010008)
    _GUICtrlListView_SetColumnWidth($idSeriesList, 0, 314)

    ; ==========================================================================
    ; トレイメニュー
    ; ==========================================================================
    $idOpenTray = TrayCreateItem("フォルダを開く")
    TrayCreateItem("")
    $idRestoreTray = TrayCreateItem("戻す")
    TrayCreateItem("")
    $idExit = TrayCreateItem("終了")
    GUISetState(@SW_SHOW, $hGUI)

    ; シーケンスファイルコンボ初期化＋先頭ファイルを自動読込
    _RefreshFileCombo()
    _RefreshSeriesFileCombo()
    _SeriesLoadFromCombo()

    While 1
        Switch TrayGetMsg()
            Case $idOpenTray
                ShellExecute(@WorkingDir)
            Case $idRestoreTray
                _RestoreData()
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

            ; ----- 単体ファイル操作 -----
            Case $idOpenBtn
                ShellExecute(@WorkingDir)
            Case $idRestoreBtn
                _RestoreData()
            Case $idNewBtn
                _AddNewDataFile()
            Case $idEditBtn
                _EditDataFile()
            Case $idDelBtn
                _DeleteDataFile()

            Case $idNotepad ; 【記録開始】
                Stop2()
                Local $sFile = _GetFileListSel()
                If FileExists($sFile) Then FileCopy($sFile, $sFile & ".bak", 1)
                GUICtrlSetState($idNotepad, $GUI_DISABLE)
                GUICtrlSetState($start, $GUI_DISABLE)
                ControlFocus($hGUI, "", $idClose1)
                $word = ""
                $record_start_flag = True
                $timer = TimerInit()
                $last_activity_timer = TimerInit()
                Local $aPos = MouseGetPos()
                $tmp_arr[0] = $aPos[0]
                $tmp_arr[1] = $aPos[1]
                $hMouseCallback = DllCallbackRegister("_MouseHookProc", "long_ptr", "int;wparam;lparam")
                $hMouseHook = _WinAPI_SetWindowsHookEx(14, DllCallbackGetPtr($hMouseCallback), _WinAPI_GetModuleHandle(0))
                WinSetTitle($hGUI, "", "記録中... [ESC]で保存")

            Case $idClose1 ; 【単体停止】
                If $record_start_flag Then
                    $file_handle = FileOpen(_GetFileListSel(), 2)
                    FileWrite($file_handle, $word)
                    _RefreshFileCombo()
                EndIf
                Stop2()

            Case $start ; 【単体開始】
                Stop2()
                GUICtrlSetState($idNotepad, $GUI_DISABLE)
                GUICtrlSetState($start, $GUI_DISABLE)
                ControlFocus($hGUI, "", $idClose1)
                $loop_count = Int(GUICtrlRead($input))
                If $loop_count <= 0 Then $loop_count = 1
                $move_num = 1
                $is_waiting = False
                $file_handle = FileOpen(_GetFileListSel(), 0)
                If $file_handle = -1 Then
                    MsgBox(16, "エラー", _GetFileListSel() & " が見つかりません。")
                    Stop2()
                    ContinueLoop
                EndIf
                WinSetTitle($hGUI, "", "＠" & $loop_count & "回 動作中")
                $play_flag = True
                AdlibRegister("_PlayExecution", 10)

            ; ----- シーケンスファイル操作 -----
            Case $idSeriesFileCombo
                _SeriesLoadFromCombo()

            Case $idSeriesNewBtn
                _SeriesNewFile()

            Case $idSeriesRenameBtn
                _SeriesRenameFile()

            Case $idSeriesFileDelBtn
                _SeriesDeleteFile()

            Case $idSeriesAdd
                _SeriesAddFile()

            Case $idSeriesUp
                _SeriesMoveItem(-1)

            Case $idSeriesDown
                _SeriesMoveItem(1)

            Case $idSeriesItemDel
                _SeriesRemoveItem()

            Case $idSeriesSave
                _SeriesSave()

            Case $idSeqClose ; 【シーケンス停止】
                Stop2()

            Case $idSeqStart ; 【シーケンス開始】
                Stop2()
                If $series_count = 0 Then
                    MsgBox(48, "エラー", "シーケンスにファイルが1つもありません。先に[追加]してください。")
                    ContinueLoop
                EndIf
                GUICtrlSetState($start, $GUI_DISABLE)
                $loop_count = Int(GUICtrlRead($idSeqInput))
                If $loop_count <= 0 Then $loop_count = 1
                $move_num = 1
                $is_waiting = False
                $series_idx = 0
                $series_is_playing = True
                _OpenSeriesFile(0)
                $play_flag = True
                AdlibRegister("_PlayExecutionSeries", 10)
        EndSwitch

        If $record_start_flag And _IsPressed("1B", $dll_user32) Then
            $file_handle = FileOpen(_GetFileListSel(), 2)
            FileWrite($file_handle, $word)
            _RefreshFileCombo()
            Stop2()
        EndIf

        If $record_start_flag Then
            Local $idle_ms = TimerDiff($last_activity_timer)
            If $idle_ms > 100 Then
                $word &= $idle_ms & ",wait" & @CRLF
                $timer = TimerInit()
                $last_activity_timer = TimerInit()
            EndIf
        EndIf

        Sleep(10)
    WEnd

    GUIDelete($hGUI)
    DllClose($dll_user32)
EndFunc   ;==>Example

; --- mouse_data* ファイル一覧を取得 ---
Func _GetDataFiles()
    Local $sList = "mouse_data"
    Local $hSearch = FileFindFirstFile(@WorkingDir & "\mouse_data*")
    If $hSearch = -1 Then Return $sList
    While 1
        Local $sF = FileFindNextFile($hSearch)
        If @error Then ExitLoop
        If $sF = "mouse_data" Or StringRight($sF, 4) = ".bak" Then ContinueLoop
        $sList &= "|" & $sF
    WEnd
    FileClose($hSearch)
    Return $sList
EndFunc

; --- .bakからデータ復元 ---
Func _RestoreData()
    Local $sFile = _GetFileListSel()
    Local $sBak = $sFile & ".bak"
    If Not FileExists($sBak) Then
        MsgBox(64, "情報", "バックアップがありません。")
        Return
    EndIf
    FileCopy($sBak, $sFile, 1)
    MsgBox(64, "情報", $sFile & " を復元しました。")
EndFunc

; --- 新規 mouse_data ファイルを追加 ---
Func _AddNewDataFile()
    Local $i = 1
    While FileExists(@WorkingDir & "\mouse_data_" & $i)
        $i += 1
    WEnd
    Local $sNew = "mouse_data_" & $i
    Local $hFile = FileOpen(@WorkingDir & "\" & $sNew, 2)
    FileClose($hFile)
    _RefreshFileCombo()
    ; 新規行を選択
    Local $hWnd = GUICtrlGetHandle($idFileCombo)
    Local $nItems = _GUICtrlListView_GetItemCount($hWnd)
    For $i = 0 To $nItems - 1
        If _GUICtrlListView_GetItemText($hWnd, $i) = $sNew Then
            _GUICtrlListView_SetItemSelected($hWnd, $i, True, True)
            ExitLoop
        EndIf
    Next
EndFunc

; --- mouse_data ファイル名を変更 ---
Func _EditDataFile()
    Local $sOld = _GetFileListSel()
    If $sOld = "" Then
        MsgBox(48, "エラー", "ファイルが選択されていません。")
        Return
    EndIf
    If Not FileExists(@WorkingDir & "\" & $sOld) Then
        MsgBox(48, "エラー", $sOld & " が見つかりません。先に記録してください。")
        Return
    EndIf
    Local $sNew = InputBox("ファイル名の変更", "新しいファイル名を入力してください。", $sOld)
    If @error Then Return
    If $sNew = "" Or $sNew = $sOld Then Return
    If StringRegExp($sNew, '[\\/:*?"<>|]') Then
        MsgBox(48, "エラー", "ファイル名に使えない文字が含まれています。")
        Return
    EndIf
    If FileExists(@WorkingDir & "\" & $sNew) Then
        MsgBox(48, "エラー", $sNew & " は既に存在します。")
        Return
    EndIf
    FileMove(@WorkingDir & "\" & $sOld, @WorkingDir & "\" & $sNew, 0)
    If @error Then
        MsgBox(48, "エラー", "リネームに失敗しました。")
        Return
    EndIf
    _RefreshFileCombo()
    ; 編集後のファイルを選択
    Local $hWnd = GUICtrlGetHandle($idFileCombo)
    Local $nItems = _GUICtrlListView_GetItemCount($hWnd)
    For $i = 0 To $nItems - 1
        If _GUICtrlListView_GetItemText($hWnd, $i) = $sNew Then
            _GUICtrlListView_SetItemSelected($hWnd, $i, True, True)
            ExitLoop
        EndIf
    Next
EndFunc

; --- mouse_data ファイルを削除 ---
Func _DeleteDataFile()
    Local $sFile = _GetFileListSel()
    If $sFile = "" Then
        MsgBox(48, "エラー", "ファイルが選択されていません。")
        Return
    EndIf
    If Not FileExists(@WorkingDir & "\" & $sFile) Then
        MsgBox(48, "エラー", $sFile & " が見つかりません。")
        Return
    EndIf
    If MsgBox(36, "確認", $sFile & " を削除しますか？") <> 6 Then Return
    FileDelete(@WorkingDir & "\" & $sFile)
    If FileExists(@WorkingDir & "\" & $sFile & ".bak") Then
        FileDelete(@WorkingDir & "\" & $sFile & ".bak")
    EndIf
    _RefreshFileCombo()
    ; "mouse_data" を選択
    Local $hWnd = GUICtrlGetHandle($idFileCombo)
    Local $nItems = _GUICtrlListView_GetItemCount($hWnd)
    For $i = 0 To $nItems - 1
        If _GUICtrlListView_GetItemText($hWnd, $i) = "mouse_data" Then
            _GUICtrlListView_SetItemSelected($hWnd, $i, True, True)
            ExitLoop
        EndIf
    Next
EndFunc

; --- コンボボックス／ListView 再読み込み ---
Func _RefreshFileCombo()
    Local $sCurrent = _GetFileListSel()
    Local $hWnd = GUICtrlGetHandle($idFileCombo)
    _GUICtrlListView_DeleteAllItems($hWnd)
    Local $sData = _GetDataFiles()
    Local $aItems = StringSplit($sData, "|")
    Local $iSelect = 0
    For $i = 1 To $aItems[0]
        GUICtrlCreateListViewItem($aItems[$i], $idFileCombo)
        If $aItems[$i] = $sCurrent Then $iSelect = $i - 1
    Next
    _GUICtrlListView_SetItemSelected($hWnd, $iSelect, True, True)
EndFunc

; --- ListView の選択中アイテムのテキストを取得 ---
Func _GetFileListSel()
    Local $hWnd = GUICtrlGetHandle($idFileCombo)
    Local $sIdx = _GUICtrlListView_GetSelectedIndices($hWnd)
    If $sIdx = "" Then Return ""
    Local $aIdx = StringSplit($sIdx, "|")
    Return _GUICtrlListView_GetItemText($hWnd, Number($aIdx[1]))
EndFunc


; ============================================================================
; ★★★ 複合シーケンス関数群 ★★★
; ============================================================================

; --- sequence_*.series ファイル一覧を取得（ファイルシステム順） ---
Func _GetSeriesFileList()
    Local $sList = ""
    Local $hSearch = FileFindFirstFile(@WorkingDir & "\sequence*.series")
    If $hSearch = -1 Then Return ""
    While 1
        Local $sF = FileFindNextFile($hSearch)
        If @error Then ExitLoop
        $sF = StringReplace($sF, ".series", "", 1)
        $sList &= "|" & $sF
    WEnd
    FileClose($hSearch)
    Return $sList
EndFunc

; --- シーケンスファイルコンボを更新 ---
Func _RefreshSeriesFileCombo()
    Local $sList = _GetSeriesFileList()
    ; 1つもなければデフォルトを作成
    If $sList = "" Then
        Local $hDefault = FileOpen(@WorkingDir & "\sequence_1.series", 2)
        FileClose($hDefault)
        $sList = "|sequence_1"
    EndIf

    Local $sCurrent = GUICtrlRead($idSeriesFileCombo)
    ; カレントが空なら先頭を自動選択
    If $sCurrent = "" Then
        Local $sTmp = $sList
        If StringLeft($sTmp, 1) = "|" Then $sTmp = StringMid($sTmp, 2)
        Local $p = StringInStr($sTmp, "|")
        If $p > 0 Then $sTmp = StringLeft($sTmp, $p - 1)
        $sCurrent = $sTmp
    EndIf
    GUICtrlSetData($idSeriesFileCombo, "|" & $sList, $sCurrent)
    $series_current_file = GUICtrlRead($idSeriesFileCombo)
EndFunc

; --- シーケンスリスト表示を更新（ListView） ---
Func _RefreshSeriesList()
    Local $hWnd = GUICtrlGetHandle($idSeriesList)
    _GUICtrlListView_DeleteAllItems($hWnd)
    If $series_count = 0 Then
        GUICtrlCreateListViewItem("（ファイルを追加してください）", $idSeriesList)
        Return
    EndIf
    For $i = 0 To $series_count - 1
        Local $sPath = $series_commands[$i]
        Local $sName = $sPath
        Local $p = StringInStr($sName, "\", 0, -1)
        If $p > 0 Then $sName = StringMid($sName, $p + 1)
        GUICtrlCreateListViewItem($i + 1 & ": " & $sName, $idSeriesList)
    Next
EndFunc

; --- 新規シーケンスファイル作成（.series 拡張子） ---
Func _SeriesNewFile()
    Local $i = 1
    While FileExists(@WorkingDir & "\sequence_" & $i & ".series")
        $i += 1
    WEnd
    Local $sDisp = "sequence_" & $i
    Local $hFile = FileOpen(@WorkingDir & "\" & $sDisp & ".series", 2)
    FileClose($hFile)

    _RefreshSeriesFileCombo()
    GUICtrlSetData($idSeriesFileCombo, $sDisp, $sDisp)
    $series_current_file = $sDisp

    $series_count = 0
    For $j = 0 To 99
        $series_commands[$j] = ""
    Next
    _RefreshSeriesList()
EndFunc

; --- シーケンスファイル名を変更 ---
Func _SeriesRenameFile()
    Local $sOld = GUICtrlRead($idSeriesFileCombo)
    If $sOld = "" Then
        MsgBox(48, "エラー", "シーケンスファイルが選択されていません。")
        Return
    EndIf
    If Not FileExists(@WorkingDir & "\" & $sOld & ".series") Then
        MsgBox(48, "エラー", $sOld & " が見つかりません。")
        Return
    EndIf
    Local $sNew = InputBox("シーケンスファイル名の変更", "新しいファイル名を入力してください。", $sOld)
    If @error Then Return
    If $sNew = "" Or $sNew = $sOld Then Return
    If StringRegExp($sNew, '[\\/:*?"<>|]') Then
        MsgBox(48, "エラー", "ファイル名に使えない文字が含まれています。")
        Return
    EndIf
    If FileExists(@WorkingDir & "\" & $sNew & ".series") Then
        MsgBox(48, "エラー", $sNew & " は既に存在します。")
        Return
    EndIf
    FileMove(@WorkingDir & "\" & $sOld & ".series", @WorkingDir & "\" & $sNew & ".series", 0)
    If @error Then
        MsgBox(48, "エラー", "リネームに失敗しました。")
        Return
    EndIf
    _RefreshSeriesFileCombo()
    GUICtrlSetData($idSeriesFileCombo, $sNew, $sNew)
    $series_current_file = $sNew
EndFunc

; --- シーケンスファイルを削除 ---
Func _SeriesDeleteFile()
    Local $sFile = GUICtrlRead($idSeriesFileCombo)
    If $sFile = "" Then
        MsgBox(48, "エラー", "シーケンスファイルが選択されていません。")
        Return
    EndIf
    If Not FileExists(@WorkingDir & "\" & $sFile & ".series") Then
        MsgBox(48, "エラー", $sFile & " が見つかりません。")
        Return
    EndIf
    If MsgBox(36, "確認", $sFile & " を削除しますか？") <> 6 Then Return
    FileDelete(@WorkingDir & "\" & $sFile & ".series")
    _RefreshSeriesFileCombo()
    $series_count = 0
    For $j = 0 To 99
        $series_commands[$j] = ""
    Next
    _RefreshSeriesList()
EndFunc

; --- コンボ選択からシーケンスを自動読込 ---
Func _SeriesLoadFromCombo()
    Local $sFile = GUICtrlRead($idSeriesFileCombo)
    If $sFile = "" Then
        $series_count = 0
        $series_current_file = ""
        _RefreshSeriesList()
        Return
    EndIf
    $series_current_file = $sFile
    _SeriesLoad()
EndFunc

; --- ファイル追加（コンボ選択を追加） ---
Func _SeriesAddFile()
    If $series_count >= 100 Then
        MsgBox(48, "エラー", "シーケンスの上限（100）に達しました。")
        Return
    EndIf
    Local $sSelected = _GetFileListSel()
    If $sSelected = "" Then
        MsgBox(48, "追加できません", "コンボボックスで追加したいファイルを選んでから「追加」を押してください。")
        Return
    EndIf
    Local $sPath = @WorkingDir & "\" & $sSelected
    If Not FileExists($sPath) Then
        MsgBox(48, "エラー", $sPath & " が見つかりません。")
        Return
    EndIf
    $series_commands[$series_count] = $sPath
    $series_count += 1
    _RefreshSeriesList()
EndFunc

; --- アイテム移動 ---
Func _SeriesMoveItem($iDir)
    If $series_count <= 1 Then Return
    Local $hWnd = GUICtrlGetHandle($idSeriesList)
    Local $sIdx = _GUICtrlListView_GetSelectedIndices($hWnd)
    If $sIdx = "" Then Return
    Local $aIdx = StringSplit($sIdx, "|")
    Local $iIdx = Number($aIdx[1])
    If $iIdx < 0 Then Return
    Local $iTarget = $iIdx + $iDir
    If $iTarget < 0 Or $iTarget >= $series_count Then Return
    Local $sTmp = $series_commands[$iIdx]
    $series_commands[$iIdx] = $series_commands[$iTarget]
    $series_commands[$iTarget] = $sTmp
    _RefreshSeriesList()
    _SelectSeriesItem($iTarget)
EndFunc

; ============================================================================
; ★★★ 複合シーケンス関数群 ★★★
; ============================================================================

; --- 選択（ListView版／他をクリアしてから選択） ---
Func _SelectSeriesItem($iIdx)
    If $iIdx < 0 Or $iIdx >= $series_count Then Return
    Local $hWnd = GUICtrlGetHandle($idSeriesList)
    ; 全行の選択を解除
    For $i = 0 To _GUICtrlListView_GetItemCount($hWnd) - 1
        _GUICtrlListView_SetItemSelected($hWnd, $i, False)
    Next
    ; 現在の行だけ選択
    _GUICtrlListView_SetItemSelected($hWnd, $iIdx, True, True)
    _GUICtrlListView_EnsureVisible($hWnd, $iIdx, False)
EndFunc

; --- シーケンスリストの全選択を解除 ---
Func _ClearSeriesSelection()
    Local $hWnd = GUICtrlGetHandle($idSeriesList)
    Local $nItems = _GUICtrlListView_GetItemCount($hWnd)
    For $i = 0 To $nItems - 1
        _GUICtrlListView_SetItemSelected($hWnd, $i, False)
    Next
EndFunc

; --- アイテム削除 ---
Func _SeriesRemoveItem()
    If $series_count = 0 Then Return
    Local $hWnd = GUICtrlGetHandle($idSeriesList)
    Local $sIdx = _GUICtrlListView_GetSelectedIndices($hWnd)
    If $sIdx = "" Then Return
    Local $aIdx = StringSplit($sIdx, "|")
    Local $iIdx = Number($aIdx[1])
    If $iIdx < 0 Then Return
    For $i = $iIdx To $series_count - 2
        $series_commands[$i] = $series_commands[$i + 1]
    Next
    $series_count -= 1
    $series_commands[$series_count] = ""
    _RefreshSeriesList()
    If $series_count > 0 Then
        If $iIdx >= $series_count Then $iIdx = $series_count - 1
        _SelectSeriesItem($iIdx)
    EndIf
EndFunc

; --- 現在のシーケンスを .series ファイルに保存（確認メッセージあり） ---
Func _SeriesSave()
    If $series_count = 0 Then
        MsgBox(48, "エラー", "シーケンスが空です。")
        Return
    EndIf
    Local $sFile = GUICtrlRead($idSeriesFileCombo)
    If $sFile = "" Then
        MsgBox(48, "エラー", "保存先のシーケンスファイルを選んでください。")
        Return
    EndIf
    Local $sPath = @WorkingDir & "\" & $sFile & ".series"
    Local $hFile = FileOpen($sPath, 2)
    If $hFile = -1 Then
        MsgBox(48, "エラー", "ファイルを開けませんでした。")
        Return
    EndIf
    For $i = 0 To $series_count - 1
        FileWriteLine($hFile, $series_commands[$i])
    Next
    FileClose($hFile)
    MsgBox(64, "保存完了", $series_count & " 個のファイルを " & $sFile & " に保存しました。")
EndFunc

; --- 現在選択中のシーケンスファイルを読み込み（.series 拡張子付加） ---
Func _SeriesLoad()
    Local $sFile = GUICtrlRead($idSeriesFileCombo)
    If $sFile = "" Then
        $series_count = 0
        $series_current_file = ""
        _RefreshSeriesList()
        Return
    EndIf
    $series_current_file = $sFile
    Local $sPath = @WorkingDir & "\" & $sFile & ".series"
    If Not FileExists($sPath) Then
        $series_count = 0
        _RefreshSeriesList()
        Return
    EndIf
    Local $hFile = FileOpen($sPath, 0)
    If $hFile = -1 Then Return
    $series_count = 0
    For $i = 0 To 99
        $series_commands[$i] = ""
    Next
    While 1
        Local $sLine = FileReadLine($hFile)
        If @error Then ExitLoop
        $sLine = StringStripWS($sLine, 3)
        If $sLine = "" Then ContinueLoop
        If $series_count < 100 Then
            If StringLen($sLine) >= 2 And _
               StringLeft($sLine, 1) <> "\" And _
               StringMid($sLine, 2, 1) <> ":" Then
                $sLine = @WorkingDir & "\" & $sLine
            EndIf
            $series_commands[$series_count] = $sLine
            $series_count += 1
        EndIf
    WEnd
    FileClose($hFile)
    _RefreshSeriesList()
EndFunc
