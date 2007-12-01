VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisDocument"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True

' $Rev$
' Copyright (C) 2005 Osamu OKANO <osamu@dkiroku.com>
'     All rights reserved.
'     This is free software with ABSOLUTELY NO WARRANTY.
'
' You can redistribute it and/or modify it under the terms of
' the GNU General Public License version 2.
'
' Copyright (C) 2005 Kazuyuki NAGAMORI <nagamori@nekoconeko.com>
'     All rights reserved.
'     This is free software with ABSOLUTELY NO WARRANTY.
'
' You can redistribute it and/or modify it under the terms of
' the GNU General Public License version 2.
'
' Copyright (C) 2007 Koki Yamamoto <kokiya@gmail.com>
'     This is free software with ABSOLUTELY NO WARRANTY.
'
' You can redistribute it and/or modify it under the terms of
' the GNU General Public License version 2.
'

Option Explicit

Private Sub SVNMenuInstall()

  Dim myCon As CommandBarPopup ' Menu control object
  Dim myBar    As CommandBar
  Dim Menu     As CommandBarControl
  Dim SubMenu1 As CommandBarButton
  Dim SubMenu2 As CommandBarButton
  Dim SubMenu3 As CommandBarButton
  Dim SubMenu4 As CommandBarButton
  Dim SubMenu5 As CommandBarButton
  Dim SubMenu6 As CommandBarButton
  Dim SubMenu7 As CommandBarButton
  Dim SubMenu8 As CommandBarButton

  For Each myCon In Application.CommandBars("Menu Bar").Controls
    If myCon.Caption = "Subversion(&S)" Then
      Exit Sub
    End If
  Next

  Set Menu = Application.CommandBars("Menu Bar").Controls.Add(Type:=msoControlPopup)
  Menu.Caption = "Subversion(&S)"

  Set SubMenu1 = Menu.Controls.Add
  SubMenu1.Caption = "�X�V(&U)"
  SubMenu1.OnAction = "TSVNUPDATE"
  SubMenu1.FaceId = 360

  Set SubMenu2 = Menu.Controls.Add
  SubMenu2.Caption = "���b�N���擾(&O)"
  SubMenu2.OnAction = "TSVNLOCK"
  SubMenu2.FaceId = 225

  Set SubMenu3 = Menu.Controls.Add
  SubMenu3.Caption = "�R�~�b�g(&C)"
  SubMenu3.OnAction = "TSVNCI"
  SubMenu3.FaceId = 359

  Set SubMenu4 = Menu.Controls.Add
  SubMenu4.Caption = "����(&D)"
  SubMenu4.OnAction = "TSVNDIFF"
  SubMenu4.FaceId = 195

  Set SubMenu5 = Menu.Controls.Add
  SubMenu5.Caption = "���O�\��(&L)"
  SubMenu5.OnAction = "TSVNLOG"
  SubMenu5.FaceId = 44
  
  Set SubMenu6 = Menu.Controls.Add
  SubMenu6.Caption = "���|�W�g���u���E�U(&R)"
  SubMenu6.OnAction = "TSVNRB"
  SubMenu6.FaceId = 25

  Set SubMenu7 = Menu.Controls.Add
  SubMenu7.Caption = "���b�N���J��(&C)"
  SubMenu7.OnAction = "TSVNUNLOCK"
  SubMenu7.FaceId = 277

  Set SubMenu8 = Menu.Controls.Add
  SubMenu8.Caption = "�ǉ�(&A)"
  SubMenu8.OnAction = "TSVNADD"
  SubMenu8.FaceId = 316

End Sub


Private Sub SVNToolBarInstall()

  Dim SVNCmdBar As CommandBar

  ' Test whether the subversion tool bar exits or not
  Dim CmdBarIdx As Long
  Dim SVNCmdBartExist As boolean

  ' If Subversion command bar already exists, exit subroutine.
  For CmdBarIdx = 1 To Application.CommandBars.Count
    If Application.CommandBars.Item(CmdBarIdx).Name = "Subversion" Then
      SVNCmdBartExist = True
      Exit Sub
    End If
  Next CmdBarIdx

  Set SVNCmdBar = Application.CommandBars.Add
  
  With SVNCmdBar
    .Enabled = True
    .Visible = True
    .NameLocal = "Subversion"

    With .Controls.Add(Type:=msoControlButton)
      .Caption = "�X�V"
      .FaceId = 360
      .OnAction = "TSVNUPDATE"
    End With
    With .Controls.Add(Type:=msoControlButton)
      .Caption = "���b�N���擾"
      .FaceId = 225
      .OnAction = "TSVNLOCK"
    End With
    With .Controls.Add(Type:=msoControlButton)
      .Caption = "�R�~�b�g"
      .FaceId = 359
      .OnAction = "TSVNCI"
    End With
    With .Controls.Add(Type:=msoControlButton)
      .Caption = "����"
      .FaceId = 195
      .OnAction = "TSVNDIFF"
    End With
    With .Controls.Add(Type:=msoControlButton)
      .Caption = "���O�\��"
      .FaceId = 44
      .OnAction = "TSVNLOG"
    End With
    With .Controls.Add(Type:=msoControlButton)
      .Caption = "���|�W�g���u���E�U"
      .FaceId = 25
      .OnAction = "TSVNRB"
    End With
    With .Controls.Add(Type:=msoControlButton)
      .Caption = "���b�N���J��"
      .FaceId = 277
      .OnAction = "TSVNUNLOCK"
    End With
    With .Controls.Add(Type:=msoControlButton)
      .Caption = "�ǉ�"
      .FaceId = 316
      .OnAction = "TSVNADD"
    End With
  End With
  Err.Clear
End Sub


Private Sub SVNDeleteMenu()
  Dim myCon As CommandBarPopup ' Command bar control object

  ' If Subversion menu exists, delete it.
  For Each myCon In Application.CommandBars("Menu Bar").Controls
    If myCon.Caption = "Subversion(&S)" Then
      Application.CommandBars("Menu Bar").Controls("Subversion(&S)").Delete
    Exit For
  End If
  Next
End Sub


Private Sub SVNDeleteCommandBar()
  Dim CmdBarIdx As Long ' Index of command bar

  With Application.CommandBars
    For CmdBarIdx = 1 To .Count
      If .Item(CmdBarIdx).Name = "Subversion" Then
        .Item(CmdBarIdx).Delete
        Exit For
      End If
    Next CmdBarIdx
  End With
End Sub


Sub AutoExec()
  SVNDeleteMenu
  SVNMenuInstall
  SVNDeleteCommandBar
  SVNToolBarInstall
End Sub


Sub AutoExit()
  SVNDeleteMenu
  SVNDeleteCommandBar
End Sub


Function TSVN(ByVal command As String, ByVal DocFileFullName As String) As Boolean
  Dim strTSVN As String
  Dim strCOM As String
  Dim strPATH As String
  strTSVN = """" & CreateObject("WScript.Shell").RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\TortoiseSVN\ProcPath") & """"
  strCOM = "/command:" & command & " /notempfile "

  If Len(DocFileFullName) = 0 Then
    strPATH = "/path:" & """" & ActiveDocument.FullName & """"
  Else
    strPATH = "/path:" & """" & DocFileFullName & """"
  End If

  CreateObject("WScript.Shell").Run strTSVN & strCOM & strPATH, , True
  TSVN = True ' Return True
End Function


Sub TSVNUPDATE()
  Dim msgActiveDocMod As String ' Message
  Dim FilePath As String ' Backup of active document full path name

  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  msgActiveDocMod = "�X�V�ł��܂���B" & "'" & ActiveDocument.Name & "'" & "�͕ύX����Ă��܂��B"

  ' Test the active document file status
  If ActiveDocFileExistWithMsg() = False Then
    Exit Sub
  End If

  ' Test the folder is under version control
  If IsFileUnderSVNControlWithMsg = False Then
    Exit Sub
  End If

  If ActiveDocument.Saved = False Then
  ' Active Document is modified but not saved yet.
    MsgBox(msgActiveDocMod)
    Exit Sub
  End If

  FilePath = ActiveDocument.FullName
  ActiveDocument.Close

  If TSVN("update", FilePath) = True Then
    Documents.Open FileName:=FilePath
  End If

End Sub


Sub TSVNCI()
  Dim msgActiveDocFileReadOnly As String ' Message
  Dim msgSaveModDoc As String            ' Message
  Dim ans As Integer     ' Return value of message box
  Dim FilePath As String ' Backup of active document full path name

  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  msgActiveDocFileReadOnly = "�R�~�b�g�ł��܂���B" & "'" & ActiveDocument.Name & "'" & "�͕ύX����Ă��܂����A�t�@�C���������ǂݎ���p�ƂȂ��Ă��܂��B"
  msgSaveModDoc = "�R�~�b�g���ɁA�t�@�C��������������čēx�J���܂��B" & "'" & ActiveDocument.Name & "'" & "�ւ̕ύX��ۑ����܂����H"

  ' Test the active document file status
  If ActiveDocFileExistWithMsg() = False Then
    Exit Sub
  End If

  ' Test the folder is under version control
  If IsFolderUnderSVNControlWithMsg = False Then
    Exit Sub
  End If

  If ActiveDocument.Saved = False Then
  ' Active Document is modified but not saved yet.
    ' Test the active document file attributes
    If IsActiveDocFileReadOnly = True Then
        MsgBox (msgActiveDocFileReadOnly)
        Exit Sub
    End If
    
    ans = MsgBox(msgSaveModDoc, vbYesNo)
    If ans = vbYes Then
      ActiveDocument.Save
    End If
  End If

  FilePath = ActiveDocument.FullName
  ActiveDocument.Close

  If TSVN("commit", FilePath) = True Then
    Documents.Open FileName:=FilePath
  End If
End Sub


Sub TSVNDIFF()
  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  ' Test the active document file status
  If ActiveDocFileExistWithMsg() = False Then
    Exit Sub
  End If

  ' Test the file is under version control
  If IsFileUnderSVNControlWithMsg = False Then
    Exit Sub
  End If

  TSVN "diff", ""

End Sub


Sub TSVNRB()
  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  TSVN "repobrowser", ""
End Sub


Sub TSVNLOG()
  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  ' Test the active document file status
  If ActiveDocFileExistWithMsg() = False Then
    Exit Sub
  End If

 ' Test the file is under version control
  If IsFileUnderSVNControlWithMsg = False Then
    Exit Sub
  End If

  TSVN "log", ""
End Sub


Sub TSVNLOCK()
  Dim ans As Integer     ' Return value of MessageBox
  Dim FilePath As String ' Backup of active document full path name
  Dim msgActiveDocFileReadOnly As String ' Message
  Dim msgSaveModDoc As String            ' Message

  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  msgActiveDocFileReadOnly = "���b�N���擾�ł��܂���B" & "'" & ActiveDocument.Name & "'" & "�͕ύX����Ă��܂����A�t�@�C���������ǂݎ���p�ƂȂ��Ă��܂��B"
  msgSaveModDoc = "���b�N���擾���ɁA�t�@�C��������������čēx�J���܂��B" & "'" & ActiveDocument.Name & "'" & "�ւ̕ύX��ۑ����܂����H"

  ' Test the active document file status
  If ActiveDocFileExistWithMsg() = False Then
    Exit Sub
  End If

  ' Test the file is under version control
  If IsFileUnderSVNControlWithMsg = False Then
    Exit Sub
  End If

  ' Backup file name before save the active document
  FilePath = ActiveDocument.FullName

  If ActiveDocument.Saved = False Then
  ' Active Document is modified but not saved yet.
    ' Test the active document file attributes
    If IsActiveDocFileReadOnly = True Then
      MsgBox (msgActiveDocFileReadOnly)
      Exit Sub
    End If
    
    ans = MsgBox(msgSaveModDoc, vbYesNo)
    If ans = vbYes Then
      ActiveDocument.Save
    End If
  End If

  ' Close the file and reopen after lock it, because the following reasons
  '  * The file attribute of read only / read write is changed after lock the file.
  '  * The file can be updated when the file in repository is newer than the working copy.
  '  * If the word open the file and svn failes to update working copy, svn require clean-up.
  ActiveDocument.Close
  
  If TSVN("lock", FilePath) = True Then
    Documents.Open FileName:=FilePath
  End If
End Sub


Sub TSVNUNLOCK()
  Dim ans As Integer     ' Return value of MessageBox
  Dim FilePath As String ' Backup of active document full path name
  Dim msgActiveDocFileReadOnly As String ' Message
  Dim msgActiveDocMod As String          ' Message

  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  msgActiveDocFileReadOnly = "���b�N���J���ł��܂���B"  & "'" & ActiveDocument.Name & "'" & "�͕ύX����Ă��܂����A�t�@�C���������ǂݎ���p�ƂȂ��Ă��܂��B"
  msgActiveDocMod = "'" & ActiveDocument.Name & "'" & "�͕ύX����Ă��܂��B���b�N�̊J���ł͕ύX���e�����|�W�g���֔��f���邱�Ƃ͂ł��܂���B���s���܂���?"

  ' Test the active document file status
  If ActiveDocFileExistWithMsg() = False Then
    Exit Sub
  End If

  ' Test the file is under version control
  If IsFileUnderSVNControlWithMsg = False Then
    Exit Sub
  End If

  ' Backup file name before save the active document
  FilePath = ActiveDocument.FullName

  If ActiveDocument.Saved = False Then
  ' Active Document is modified but not saved yet.
    If IsActiveDocFileReadOnly = True Then
    ' Test the active document file attributes
      MsgBox (msgActiveDocFileReadOnly)
      Exit Sub
    End If

    ans = MsgBox(msgActiveDocMod, vbYesNo)

    If ans = vbNo Then
      Exit Sub ' Exit subroutine without locking
    Else
      ActiveDocument.Save
    End If
  End If ' If ActiveDocument.Saved = False Then

  ' Close the file and reopen after unlock it, because the following reason
  '  * The file attribute of read only / read write is changed after unlock the file.
  ActiveDocument.Close

  If TSVN("unlock", FilePath) = True Then
    Documents.Open FileName:=FilePath
  End If

End Sub


Sub TSVNADD()
  Dim msgActiveDocFileReadOnly As String ' Message
  Dim msgSaveModDoc As String            ' Message
  Dim ans As Integer     ' Return value of message box
  Dim FilePath As String ' Backup of active document full path name

  ' Exit when no document is open
  If Documents.Count = 0 Then
    Exit Sub
  End If

  msgActiveDocFileReadOnly = "�R�~�b�g�ł��܂���B" & "'" & ActiveDocument.Name & "'" & "�͕ύX����Ă��܂����A�t�@�C���������ǂݎ���p�ƂȂ��Ă��܂��B"
  msgSaveModDoc = "�R�~�b�g���ɁA�t�@�C��������������čēx�J���܂��B" & "'" & ActiveDocument.Name & "'" & "�ւ̕ύX��ۑ����܂����H"

  ' Test the active document file status
  If ActiveDocFileExistWithMsg() = False Then
    Exit Sub
  End If

  ' Test the folder is under version control
  If IsFolderUnderSVNControlWithMsg = False Then
    Exit Sub
  End If

  If ActiveDocument.Saved = False Then
  ' Active Document is modified but not saved yet.
    ' Test the active document file attributes
    If IsActiveDocFileReadOnly = True Then
        MsgBox (msgActiveDocFileReadOnly)
        Exit Sub
    End If
    
    ans = MsgBox(msgSaveModDoc, vbYesNo)
    If ans = vbYes Then
      ActiveDocument.Save
    End If
  End If

   If TSVN("add", "") = True Then
      ans = MsgBox("�ǉ������|�W�g���֔��f���܂���?", vbYesNo)
      If ans = vbYes Then
          TSVNCI
      End If
  End If
End Sub


' :Function:Test whether the active document is saved as a file or not.
' :Return value:True=The file exists., False=No file exists.
Function ActiveDocFileExist() As Boolean
  If ActiveDocument.Path = "" Then
    ' Judge that no file exists when no path exists.
    ActiveDocFileExist = False
  Else
    ActiveDocFileExist = True
  End If
End Function


' :Function:Test whether the active document is saved as a file or not.
'           And this displays error message if the file does't exist.
' :Return value:True=The file exists., False=No file exists.
Function ActiveDocFileExistWithMsg() As Boolean
  Dim msgActiveDocFileNotExist As String
  msgActiveDocFileNotExist = "'" & ActiveDocument.Name & "'" & "�̃t�@�C��������܂���B�������t�@�C���ɕۑ����Ă��炱�̑�����s���Ă��������B"

  If ActiveDocFileExist Then
    ActiveDocFileExistWithMsg = True
  Else
    MsgBox (msgActiveDocFileNotExist)
    ActiveDocFileExistWithMsg = False
  End If
End Function


' :Function: Test whether the active document file is read only or not.
' :Retrun value: True = Read Only, False = Not Read Only
Function IsActiveDocFileReadOnly() As Boolean
  Dim glFSO As Object  ' File System Object
  Set glFSO = CreateObject("Scripting.FileSystemObject")

  If glFSO.GetFile(ActiveDocument.FullName).Attributes And 1 Then
    IsActiveDocFileReadOnly = True  ' Return True
  Else
    IsActiveDocFileReadOnly = False ' Return False
  End If
End Function


' :Function: Test whether the file exist in the file under SVN version control.
' :Return value: True=Under version control, False=Not under version control
Function IsFolderUnderSVNControl() As Boolean
  Dim strDotSvn As String ' SVN control folder ".svn"
  strDotSvn = ActiveDocument.Path & "\.svn"

  If CreateObject("Scripting.FileSystemObject").FolderExists(strDotSvn) Then
    IsFolderUnderSVNControl = True  ' Return True
  Else
    IsFolderUnderSVNControl = False ' Return False
  End If
End Function


' :Function: Test whether the file exist in the folder under SVN version control.
'            And this displays error message if the folder isn't under version control.
' :Return value: True=Under version control, False=Not under version control
Function IsFolderUnderSVNControlWithMsg() As Boolean
  Dim msgNotUnderCtrl As String ' Message
  msgNotUnderCtrl = "'" & ActiveDocument.Name & "'" & "�̓o�[�W�����R���g���[�����̃t�H���_�ɂ���܂���B"
  
  If IsFolderUnderSVNControl Then
    IsFolderUnderSVNControlWithMsg = True 'Return True
  Else
    MsgBox (msgNotUnderCtrl)
    IsFolderUnderSVNControlWithMsg = False 'Return False
  End If
End Function


Function IsFileUnderSVNControl() As Boolean
  Dim strTextBase As String ' Base file full path name
  strTextBase = ActiveDocument.Path & "\.svn\text-base\" & ActiveDocument.Name & ".svn-base"

  If CreateObject("Scripting.FileSystemObject").FileExists(strTextBase) Then
    IsFileUnderSVNControl = True  ' Return True
  Else
    IsFileUnderSVNControl = False ' Return False
  End If
End Function


Function IsFileUnderSVNControlWithMsg() As Boolean
  Dim msgNotUnderCtrl As String ' Message
  msgNotUnderCtrl = "'" & ActiveDocument.Name & "'" & "�̓o�[�W�����R���g���[������Ă��܂���B"

  If IsFileUnderSVNControl Then
    IsFileUnderSVNControlWithMsg = True  ' Return True
  Else
    MsgBox (msgNotUnderCtrl)
    IsFileUnderSVNControlWithMsg = False ' Return False
  End If
End Function
