﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private ASCheckbox1 As ASCheckbox
End Sub

Public Sub Initialize
	
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("frm_main")
	#If B4I
	Wait For B4XPage_Resize (Width As Int, Height As Int)
	#End If
	ASCheckbox1.Checked = True
	
End Sub

'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.

Sub ASCheckbox1_CheckedChange(Checked As Boolean)
	Log("Checked: " & Checked)
End Sub
