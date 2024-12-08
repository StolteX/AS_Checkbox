B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
#if Documentation
Updates
V1.00
	-Release
V1.01
	-Add CheckedAnimated
	-B4J BugFix Label Size was resizing if the font was to big
V1.02
	-Add HapticFeedback
V1.03
	-Checked was readonly
V1.04
	-Add DisabledBackgroundColor property and designer property
	-Add DisabledIconColor property and designer property
	-Add Enable property - enable or disable the view
	-no animation if you change the checked state via code
V1.05
	-B4I No Jump animation if the BorderCornerRadius > 0 (the radius cannot be held during animation, so it looks buggy when you have e.g. a circle)
	-BugFix - Enabled = False, now the view is disabled, no touch gestures allowed
V1.06
	-Intern Function IIF renamed to iif2
V1.07
	-Add DesingerProperty Checked - if true then the checkbox is checked
	-Add DesingerProperty Enabled - if false then the checkbox is disabled
		-On B4A and B4J the core enabled property in the designer is not used anymore
	-BugFixes
	-Intern Function iif2 removed and the core iif is now used
		-B4A V9.10+ - B4J V9.10+ - B4I V7.50+
V1.08
	-BugFix - When creating the view the CheckedChange event was triggered with parameter "False"
V1.09
	-Add Event property - If False then the CheckedChange event is not triggered
V1.10
	-Base_Resize is now public
V1.11
	-Intern Improvements
	-Add get and set IconColor
V1.12
	-Add set Checked2 - Without the CheckedChange Event
#End If


#DesignerProperty: Key: CheckedBackgroundColor, DisplayName: Checked Background Color, FieldType: Color, DefaultValue: 0xFF2D8879 
#DesignerProperty: Key: IconColor, DisplayName: Icon Color, FieldType: Color, DefaultValue: 0xFFFFFFFF
#DesignerProperty: Key: DisabledBackgroundColor, DisplayName: Disabled Background Color, FieldType: Color, DefaultValue: 0xFF3C4043
#DesignerProperty: Key: DisabledIconColor, DisplayName: Disabled Icon Color, FieldType: Color, DefaultValue: 0x98FFFFFF
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 2, MinRange: 1
#DesignerProperty: Key: BorderCornerRadius, DisplayName: Border Corner Radius, FieldType: Int, DefaultValue: 10, MinRange: 0
#DesignerProperty: Key: CheckedAnimated, DisplayName: Checked Animated, FieldType: Boolean, DefaultValue: True
#DesignerProperty: Key: HapticFeedback, DisplayName: Haptic Feedback, FieldType: Boolean, DefaultValue: True, Description: Whether to make a haptic feedback when the user clicks on the control.
#DesignerProperty: Key: Checked, DisplayName: Checked, FieldType: Boolean, DefaultValue: False
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True

#Event: CheckedChange(Checked As Boolean)

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Public Tag As Object
	Private xlbl_background As B4XView
	
	Private m_Icon As String 
	Private m_isFontAswesome As Boolean = False
	Private m_IconColor As Int
	Private m_CheckedBackgroundColor As Int
	Private m_DisabledColor As Int
	Private m_DisabledIconColor As Int
	Private m_isChecked As Boolean = False
	Private m_BorderWidth As Int
	Private m_BorderCornerRadius As Int
	Private m_isCheckedAnimated As Boolean
	Private m_isHaptic As Boolean'Ignore
	Private m_isEvent As Boolean = True
	Private m_isEnabled As Boolean
	
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
    Tag = mBase.Tag
    mBase.Tag = Me 
	ini_props(Props)
	xlbl_background = CreateLabel("xlbl_background")
	mBase.AddView(xlbl_background,0,0,0,0)
	
	xlbl_background.Enabled = m_isEnabled
	
	m_Icon = Chr(0xE5CA)
	
	Base_Resize(mBase.Width,mBase.Height)
	
	Check(m_isChecked,False,False)
End Sub

Private Sub ini_props(Props As Map)
	m_isEnabled = Props.GetDefault("Enabled",True)
	
	m_CheckedBackgroundColor = xui.PaintOrColorToColor(Props.Get("CheckedBackgroundColor"))
	m_IconColor = xui.PaintOrColorToColor(Props.Get("IconColor"))
	m_DisabledColor = xui.PaintOrColorToColor(Props.Get("DisabledBackgroundColor"))
	m_DisabledIconColor = xui.PaintOrColorToColor(Props.Get("DisabledIconColor"))
	m_BorderWidth = Props.Get("BorderWidth")
	m_BorderCornerRadius = Props.Get("BorderCornerRadius")
	m_isCheckedAnimated = Props.Get("CheckedAnimated")
	m_isHaptic = Props.Get("HapticFeedback")
	m_isChecked = Props.GetDefault("Checked",False)
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
	xlbl_background.SetLayoutAnimated(0,0,0,Width,Height)
	#If B4J
	Dim jo As JavaObject = xlbl_background
	jo.RunMethod("setMinSize", Array(Width/2, Height/2))
	jo.RunMethod("setMaxSize", Array(Width, Height))
	#End If
	UpdateStyle
End Sub

Private Sub UpdateStyle
	Dim clr_background As Int = m_CheckedBackgroundColor	
	If m_isEnabled = False Then clr_background = m_DisabledColor
	
	Dim clr_icon As Int = m_IconColor
	If m_isEnabled = False Then clr_icon = m_DisabledIconColor
	
	If m_isChecked = False Then
		xlbl_background.SetColorAndBorder(xui.Color_Transparent,m_BorderWidth,clr_background,m_BorderCornerRadius)
	Else
		xlbl_background.SetColorAndBorder(clr_background,m_BorderWidth,clr_background,m_BorderCornerRadius)
		xlbl_background.TextColor = clr_icon
	End If
End Sub


Public Sub setChecked(b_checked As Boolean)
	m_isChecked = b_checked
	Check(b_checked,m_isCheckedAnimated,True)
End Sub

'Without the CheckedChange Event
Public Sub setChecked2(Checked As Boolean)
	m_isChecked = Checked
	Check(Checked,m_isCheckedAnimated,False)
End Sub

Public Sub getChecked As Boolean
	Return m_isChecked
End Sub

Private Sub Check(b_checked As Boolean,animated As Boolean,WithEvent As Boolean)
	
	If b_checked Then
		'xlbl_background.Color = m_CheckedBackgroundColor
		'xlbl_background.TextColor = m_IconColor
		UpdateStyle
		xlbl_background.SetTextAlignment("CENTER","CENTER")
		xlbl_background.Text = m_Icon
		xlbl_background.Font = IIf(m_isFontAswesome = False,xui.CreateMaterialIcons(1),xui.CreateFontAwesome(1))
		Dim size As Float = 2
		For size = 2 To 500
			If CheckSize(size) Then Exit
		Next
		If size > 10 Then size = size - 5
		
		If m_isCheckedAnimated = True And animated = True Then
			xlbl_background.Font = IIf(m_isFontAswesome = False,xui.CreateMaterialIcons(1),xui.CreateFontAwesome(1))
		
			Jump
			If (m_BorderCornerRadius <> 0 And xui.IsB4i = False) Or m_BorderCornerRadius = 0 Then
				Sleep(250)
			End If
			
			
			xlbl_background.SetTextSizeAnimated(250,size)
		Else
			xlbl_background.Font = IIf(m_isFontAswesome = False,xui.CreateMaterialIcons(size),xui.CreateFontAwesome(size))
		End If
	
	Else
		xlbl_background.Color = xui.Color_Transparent
		xlbl_background.Text = ""
		Sleep(0)
		If m_isCheckedAnimated = True And animated = True Then Jump
	End If
	If WithEvent = True And m_isEvent = True Then
		CheckedChange
	End If
End Sub
'https://www.b4x.com/android/forum/threads/iamir_viewanimator.100194/#content
Private Sub Jump	
	#If B4I
'	Dim tmp_lbl As Label = xlbl_background	
'	tmp_lbl.SetLayoutAnimated(250,1,mBase.Width/4,mBase.Height/4,mBase.Width/2,mBase.Height/2)
'	Sleep(250)
'	tmp_lbl.SetLayoutAnimated(250,1,0,0,mBase.Width,mBase.Height)
	#Else
	xlbl_background.SetLayoutAnimated(250,mBase.Width/4,mBase.Height/4,mBase.Width/2,mBase.Height/2)
	Sleep(250)
	xlbl_background.SetLayoutAnimated(250,0,0,mBase.Width,mBase.Height)
	#End If
End Sub


Public Sub SetIcon(icon As String,isfontawesome As Boolean)
	m_Icon = icon
	m_isFontAswesome = isfontawesome
	If m_isChecked = True Then Check(m_isChecked,False,False)
End Sub

Public Sub setBorderCornerRadius(radius As Int)
	m_BorderCornerRadius = radius
	UpdateStyle
End Sub

Public Sub setBorderWidth(width As Int)
	m_BorderWidth = width
	UpdateStyle
End Sub

Public Sub getIconColor As Int
	Return m_IconColor
End Sub

Public Sub setIconColor(Color As Int)
	m_IconColor = Color
	UpdateStyle
End Sub

Public Sub setCheckedBackgroundColor(crl As Int)
	m_CheckedBackgroundColor = crl
	UpdateStyle
End Sub

Public Sub setCheckedAnimated(animated As Boolean)
	m_isCheckedAnimated = animated
End Sub

Public Sub setEnabled(enable As Boolean)
	m_isEnabled = enable
	mBase.Enabled = enable
	xlbl_background.Enabled = enable
	UpdateStyle
End Sub

Public Sub getEnabled As Boolean
	Return m_isEnabled
End Sub

Public Sub getDisabledBackgroundColor As Int
	Return  m_DisabledColor
End Sub

Public Sub setDisabledBackgroundColor(crl As Int)
	m_DisabledColor = crl
	UpdateStyle
End Sub

Public Sub getDisabledIconColor As Int
	Return  m_DisabledIconColor
End Sub

Public Sub setDisabledIconColor(crl As Int)
	m_DisabledIconColor = crl
	UpdateStyle
End Sub

Public Sub getisHaptic As Boolean
	Return m_isHaptic
End Sub

Public Sub setisHaptic(Enabled As Boolean)
	m_isHaptic = Enabled
End Sub

Public Sub getisEvent As Boolean
	Return m_isEvent
End Sub

Public Sub setisEvent(Enabled As Boolean)
	m_isEvent = Enabled
End Sub

Public Sub getisFontAswesome As Boolean
	Return m_isFontAswesome
End Sub

Public Sub setisFontAswesome(FontAwesome As Boolean)
	m_isFontAswesome = FontAwesome
End Sub

#If B4J
Private Sub xlbl_background_MouseClicked (EventData As MouseEvent)
	If m_isEnabled = False Then Return
	If m_isChecked = True Then
		setChecked(False)
		Else
		setChecked(True)
	End If
End Sub
#Else
Private Sub xlbl_background_Click
	If m_isEnabled = False Then Return
	If m_isHaptic Then XUIViewsUtils.PerformHapticFeedback(mBase)
	If m_isChecked = True Then
		m_isChecked = False
		Check(m_isChecked,m_isCheckedAnimated,True)
	Else
		m_isChecked = True
		Check(m_isChecked,m_isCheckedAnimated,True)
	End If
End Sub
#End If

Private Sub CreateLabel(EventName As String) As B4XView
	Dim tmp_lbl As Label : tmp_lbl.Initialize(EventName)
	Return tmp_lbl
End Sub

'returns true if the size is too large
Private Sub CheckSize(size As Float) As Boolean
	xlbl_background.TextSize = size
	
		#if b4A
		Dim stuti As StringUtils
		Return MeasureTextWidth(xlbl_background.Text,xlbl_background.Font) > xlbl_background.Width Or stuti.MeasureMultilineTextHeight(xlbl_background,xlbl_background.Text) > xlbl_background.Height		
		#Else		
	Return MeasureTextWidth(xlbl_background.Text,xlbl_background.Font) > xlbl_background.Width Or MeasureTextHeight(xlbl_background.Text,xlbl_background.Font) > xlbl_background.Height
		#End If
		
End Sub

'https://www.b4x.com/android/forum/threads/b4x-xui-add-measuretextwidth-and-measuretextheight-to-b4xcanvas.91865/#content
Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int
#If B4A
	Private bmp As Bitmap
	bmp.InitializeMutable(1, 1)'ignore
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringWidth(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
    Return Text.MeasureWidth(Font1.ToNativeFont)
#Else If B4J
	Dim jo As JavaObject
	jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
	jo.RunMethod("setFont",Array(Font1.ToNativeFont))
	jo.RunMethod("setLineSpacing",Array(0.0))
	jo.RunMethod("setWrappingWidth",Array(0.0))
	Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
	Return Bounds.RunMethod("getWidth",Null)
#End If
End Sub

'https://www.b4x.com/android/forum/threads/b4x-xui-add-measuretextwidth-and-measuretextheight-to-b4xcanvas.91865/#content
Private Sub MeasureTextHeight(Text As String, Font1 As B4XFont) As Int'Ignore
#If B4A     
	Private bmp As Bitmap
	bmp.InitializeMutable(1, 1)'ignore
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringHeight(Text, Font1.ToNativeFont, Font1.Size)
	
#Else If B4i
    Return Text.MeasureHeight(Font1.ToNativeFont)
#Else If B4J
	Dim jo As JavaObject
	jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
	jo.RunMethod("setFont",Array(Font1.ToNativeFont))
	jo.RunMethod("setLineSpacing",Array(0.0))
	jo.RunMethod("setWrappingWidth",Array(0.0))
	Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
	Return Bounds.RunMethod("getHeight",Null)
#End If
End Sub

#Region Events

Private Sub CheckedChange
	If xui.SubExists(mCallBack,mEventName & "_CheckedChange",1) Then
		CallSub2(mCallBack,mEventName & "_CheckedChange",m_isChecked)
	End If
End Sub

#End Region