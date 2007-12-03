VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisWorkbook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' Copyright (C) 2005 Osamu OKANO <osamu@dkiroku.com>
'     All rights reserved.
'     This is free software with ABSOLUTELY NO WARRANTY.
'
' You can redistribute it and/or modify it under the terms of
' the GNU General Public License version 2.
'
' Copyright (C) 2007 Koki Yamamoto <kokiya@gmail.com>
'     All rights of modified contents from original one are reserved
'     This is free software with ABSOLUTELY NO WARRANTY.
'
' You can redistribute it and/or modify it under the terms of
' the GNU General Public License version 2.

Option Explicit

Private Sub Workbook_AddinInstall()

    ' Build the SVN Menu
    InstallMenu
    ' Build the SVN CommandBar
    InstallCmdBar

End Sub


Private Sub Workbook_AddinUninstall()
    Application.CommandBars("Worksheet Menu Bar").Controls("Subversion(&S)").Delete
    Application.CommandBars("Subversion").Delete
End Sub


Private Sub InstallCmdBar()
    ' Build the SVN CommandBar
    Dim SVNCmdBar As CommandBar
    Set SVNCmdBar = Application.CommandBars.Add

    With SVNCmdBar
      .NameLocal = "Subversion"
      .Enabled = True
      .Visible = True
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
    End With
End Sub


Private Sub InstallMenu()

  Dim Menu     As CommandBarControl
  Dim SubMenu1 As CommandBarButton
  Dim SubMenu2 As CommandBarButton
  Dim SubMenu3 As CommandBarButton
  Dim SubMenu4 As CommandBarButton
  Dim SubMenu5 As CommandBarButton
  Dim SubMenu6 As CommandBarButton
  Dim SubMenu7 As CommandBarButton

  ' Build the SVN Menu
    Set Menu = Application.CommandBars("Worksheet Menu Bar").Controls.Add(Type:=msoControlPopup)
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
End Sub

