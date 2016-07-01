#NoENV
; 预计功能: 根据正则分析标题，生成包含目录的ebook文件
VerDate := "2016-07-01"
; 2013-5-7: mobigen生成的mobi格式在Kindle PaperWhite上，跳转目录显示为乱码，需使用kindlegen

	FoxDir := FoxReg("保存目录")
	If ( FoxDir = -5 )
		FoxDir := A_scriptdir

LVListPath := FoxDir . "\FoxListView.txt"
FoxVar("BookCreator", "爱尔兰之狐") ; ---

SettingMenu("初始化设置") ; 初始化菜单项设置

FoxRElist =
(Join`n
Ui)(第.{1,5}章)
Ui)([第]?[0-9零○一二两三四五六七八九十百千廿卅卌壹贰叁肆伍陆柒捌玖拾佰仟万１２３４５６７８９０]{1,5}[章节節堂讲回集部分]?)
Ui)(第[0-9零○一二两三四五六七八九十百千廿卅卌壹贰叁肆伍陆柒捌玖拾佰仟万１２３４５６７８９０]{1,5}[章节節堂讲回集部分]{1})
Ui)([0-9]{1,5}\.)
)
FoxRECount := FoxReg("正则表达式计数")
if FoxRECount is integer
{
	if ( FoxRECount > 0 ) {
		FoxRElist := ""
		loop, %FoxRECount%
			FoxRElist .= FoxReg("正则表达式_" . A_index) . "`n"
	}
}


Gui +LastFound +Resize +MinSize480x425 + MaxSize600x500
hGUI := WinExist()  ; 该参数影响 选项菜单

Gosub, MenuInit
NewGuiInit:
;	If A_IsCompiled
;		Gui, +AlwaysOnTop
	Gui, +Delimiter`n
	Gui, Add, GroupBox, x6 y10 w460 h50 cBlue, 第一步: 正则表达式定位标题，影响拖入文件处理过程
	Gui, Add, CheckBox, x16 y30 w110 h20 cGreen Checked vCK1, 标题正则定位:
	Gui, Add, ComboBox, x126 y30 w180 h20 R20 Choose1 vRE1, %FoxRElist%
	Gui, Add, CheckBox, x316 y30 w100 h20 cGreen Checked vCK2, 最长字符数:
	Gui, Add, Edit, x416 y30 w40 h20 vEdt1, 25

	Gui, Add, GroupBox, x6 y70 w460 h270 cBlue, 第二步: 拖动Txt文件到下面，列表可编辑并影响生成结果
	Gui, Add, Button, x346 y67 w100 h20 vAddnFile gAddnFile, 选择文件(&O)
	Gui, Add, ListView, x16 y90 w440 h240 NoSortHdr -ReadOnly vFoxLV gClickLV, 标题`n行号
		 LV_ModifyCol(1, 320) , LV_ModifyCol(2, 90)

	Gui, Add, GroupBox, x6 y350 w460 h50 cBlue, 第三步: 处理过程选项，确认后按顶部菜单 生成eBook
	Gui, Add, CheckBox, x16 y370 w110 h20 cGreen Checked vCK3, 删除行首空白:
	Gui, Add, ComboBox, x126 y370 w140 h20 R20 Choose1 vRE2, i)^[ \t　]*(.*)$
	Gui, Add, CheckBox, x276 y370 w140 h20 cGreen Checked vCK4, 行首添加两中文空格

	Gui, Add, StatusBar, , 作者: 爱尔兰之狐  QQ: 308639546  版本: %VerDate%
	General_MenuBarRightJustify(hGUI, 3)
	; Generated using SmartGUI Creator 4.0
	Gui, Show, h425 w480, Txt 转 eBook 版本: %VerDate%
	onmessage(0x100, "FoxInput")  ; 在特殊控件按下特殊按键的反应
Return

MenuInit: ; 菜单栏
	Menu, SiteMenu, Add, 置顶(&T), ZhiDing
	Menu, SiteMenu, Add
	Menu, SiteMenu, Add, 热键说明, FoxMenuAct
	Menu, SiteMenu, Add
	Menu, SiteMenu, Add, 关于作者(&A), FoxMenuAct
	Menu, SiteMenu, Add
	Menu, SiteMenu, Add, 作者作品页(&L), FoxMenuAct
	Menu, SiteMenu, Add, 作者作品页国内镜像(&M), FoxMenuAct
	Menu, SiteMenu, Add, www.olsoul.com(&W), FoxMenuAct
	Menu, MyMenuBar, Add, 帮助(&H), :SiteMenu

	SettingMenu("添加菜单", 1)
	SettingMenu("添加菜单", 2)
	SettingMenu("添加菜单", 3)
	Menu, sMenu, Add
	SettingMenu("添加菜单", 4)
	SettingMenu("添加菜单", 5)
	Menu, sMenu, Add
	Menu, sMenu, Add, 设置封面图片, FoxMenuAct
	Menu, sMenu, Add, 保存目录(默认为程序所在目录), FoxMenuAct
	Menu, sMenu, Add, 还原为默认设置, FoxMenuAct
	Menu, MyMenuBar, Add, 设置(&C), :sMenu

	Menu, aMenu, Add, 导出LV, FoxMenuAct
	Menu, aMenu, Add, 清空LV, FoxMenuAct
	Menu, aMenu, Add, 导入LV, FoxMenuAct
	Menu, aMenu, Add
	Menu, aMenu, Add, XML(&L), FoxMenuAct
	Menu, aMenu, Add, UMD(&U), FoxMenuAct
	Menu, aMenu, Add, PDF(&P), FoxMenuAct
	Menu, aMenu, Add, Epub(&E), FoxMenuAct
	Menu, aMenu, Add, Mobi(&M), FoxMenuAct
	Menu, MyMenuBar, Add, 动作(&A), :aMenu

	Menu, MyMenuBar, Add, XML(&L), FoxMenuAct
	Menu, MyMenuBar, Add
	Menu, MyMenuBar, Add, UMD(&U), FoxMenuAct
	Menu, MyMenuBar, Add, PDF(&P), FoxMenuAct
	Menu, MyMenuBar, Add, Epub(&E), FoxMenuAct
	Menu, MyMenuBar, Add, Mobi(&M), FoxMenuAct
	Gui, Menu, MyMenuBar
return

ZhiDing:
	If ( A_thismenuitem = "置顶(&T)" ) {
		isNormal := ! isNormal
		If isNormal
		{
			Gui, +AlwaysOnTop
			Menu, SiteMenu, Check, 置顶(&T)
		} else {
			Gui, -AlwaysOnTop
			Menu, SiteMenu, UnCheck, 置顶(&T)
		}
	}
return

FoxMenuAct:
	If ( A_ThisMenuItem = "不带BOM的UTF8编码" )
		SettingMenu("切换按钮", 1)
	If ( A_ThisMenuItem = "拖入文件时清空列表" )
		SettingMenu("切换按钮", 2)
	If ( A_ThisMenuItem = "拖入处理标题时删除头部空格" )
		SettingMenu("切换按钮", 3)
	If ( A_ThisMenuItem = "删除空白行" )
		SettingMenu("切换按钮", 4)
	If ( A_ThisMenuItem = "删除转换过程中的临时文件" )
		SettingMenu("切换按钮", 5)
	; -------------------
	If ( A_ThisMenuItem = "还原为默认设置" )
		SettingMenu("还原为默认设置")
	If ( A_ThisMenuItem = "设置封面图片" ) {
		FileSelectFile, NowCoverPath , 1, , 选择eBook文件的封面图片(jpg，png，gif格式),封面图片格式(*.jpg;*.jpeg;*.png;*.gif)
		FoxVar("CoverPicPath", NowCoverPath)
		SB_SetText("当前封面图片路径: " . NowCoverPath)
	}
	If ( A_ThisMenuItem = "保存目录(默认为程序所在目录)" ) {
		FileSelectFolder, FoxDir, *%A_scriptdir%, 1, 选择生成eBook文件保存目录
		If ( FoxDir = "" )
			FoxDir := A_scriptdir
		else
			FoxReg("保存目录", FoxDir)
		SB_SetText("当前eBook保存目录: " . FoxDir)
	}

	If ( A_ThisMenuItem = "XML(&L)" ) {
		EpubOutExt := "xml"
		gosub, Txt2eBook
	}
	If ( A_ThisMenuItem = "Mobi(&M)" ) {
		EpubOutExt := "mobi"
		gosub, Txt2eBook
	}
	If ( A_ThisMenuItem = "Epub(&E)" ) {
		EpubOutExt := "epub"
		gosub, Txt2eBook
	}
	If ( A_ThisMenuItem = "PDF(&P)" ) {
		EpubOutExt := "pdf"
		gosub, Txt2eBook
	}
	If ( A_ThisMenuItem = "UMD(&U)" ) {
		EpubOutExt := "umd"
		gosub, Txt2eBook
	}
	If ( A_ThisMenuItem = "清空LV" ) {
		msgbox, 4, 确认, 建议你按导出LV菜单以保存列表框中的数据`n你确定要清空列表框中的数据？
		Ifmsgbox, Yes
			LV_Delete()
	}
	If ( A_ThisMenuItem = "导入LV" ) {
		Fileread, NR, %LVListPath%
		loop, parse, NR, `n, `r
		{
			If ( A_loopfield = "" )
				continue
			FF_1 := "" , FF_2 := ""
			stringsplit, FF_, A_loopfield, >, %A_space%
			LV_Add("", FF_1, FF_2)
		}
		SB_SetText("LV数据导入完毕: " . LVListPath)
	}
	If ( A_ThisMenuItem = "导出LV" ) {
		IfExist, %LVListPath%
			FileMove, %LVListPath%, %LVListPath%.%A_now%, 0
		Loop % LV_GetCount()
		{
			LV_GetText(NowTitle, A_Index, 1) , LV_GetText(NowNum, A_Index, 2)
			FileAppend, %NowTitle%>%NowNum%`n, %LVListPath%
		}
		SB_SetText("LV数据导出完毕: " . LVListPath)
	}
	If ( A_ThisMenuItem = "热键说明" ) {
		FoxSaid =
		(Ltrim Join`n
		Ctrl + A : 选中所有行
		Ctrl + Del : 删除选中行
		Ctrl + Insert : 在当前行前插入一行
		Ctrl + Up : 向上移动当前行
		Ctrl + Down : 向下移动当前行
		)
		TrayTip, 热键说明, %FoxSaid%
	}
	If ( A_thismenuitem = "www.olsoul.com(&W)" )
		OpenURL("http://www.olsoul.com")
	If ( A_thismenuitem = "关于作者(&A)" )
		TrayTip, 爱尔兰之狐:, QQ: 308639546`nhttp://linpinger.github.io
	If ( A_thismenuitem = "作者作品页(&L)" )
		OpenURL("http://linpinger.github.io?s=ExeTxt2eBook")
	If ( A_thismenuitem = "作者作品页国内镜像(&M)" )
		OpenURL("http://linpinger.oschina.io?s=ExeTxt2eBook")
return


AddnFile:
	FileSelectFile, Userselecttxt, 3, , , Novel Txt File(*.txt)
	if ( Userselecttxt = "" )
		return
	IfNotExist, %Userselecttxt%
		return
	SrcFilePath := Userselecttxt
	gosub, ReDragFile
return


ClickLV:
	If ( A_GuiEvent = "D" ) {
		RowNumber := 0 , SelectCount := 0
		Loop {
			RowNumber := LV_GetNext(RowNumber)
			if not RowNumber
			break
			++SelectCount
		}
		SB_SetText("选择记录数: " . SelectCount)
	}
return

GuiDropFiles:	; 拖动事件
	SrcFilePath := A_GuiEvent , FileCount := A_EventInfo

	If ( A_GuiControl != "FoxLV" ) {
		TrayTip, 提示:, 请将文本文件拖动到: 最大的列表框中
		return
	}

	If ( FileCount != 1 ) {
		TrayTip, 提示:, 一次处理一个文件
		return
	}

ReDragFile: ; 重新检测文件
	Gui, submit, nohide
	If ( "是" = FoxVar("CleanLV") )
		LV_Delete()
	FoxReg("上次文件路径", SrcFilePath)
	If ( "是" = FoxVar("NoBOMHead") )
		FileEncoding, UTF-8-RAW
	else
		FileEncoding
	Fileread, NR, %SrcFilePath%
	SB_SetText("稍候，正则处理文件中...")
	sTime := A_TickCount

	; 以文件名当作书名
	SplitPath, SrcFilePath, , , , OutNameNoExt
	if OutNameNoExt is integer
	{   ; 当文件名是数字时取第一行做书名
		FileReadLine, BookName, %SrcFilePath%, 1
		If ( BookName != "" )
			LV_Add("", BookName, "★书名行，按F2修改，勿删本行★")
		else
			LV_Add("", "FoxBook", "★书名行，按F2修改，勿删本行★")
	} else {
		LV_Add("", OutNameNoExt, "★书名行，按F2修改，勿删本行★")
	}

	FileReadLine, Creator, %SrcFilePath%, 2
	if ( "" != Creator )
		LV_Add("", Creator, "★作者行，按F2修改，勿删本行★")
	else
		LV_Add("", "爱尔兰之狐", "★作者行，按F2修改，勿删本行★")
	loop, parse, NR, `n, `r
	{
		If ( CK2 = 1 ) {
			If ( StrLen(A_loopfield) > Edt1 )
				Continue
		}
		If ( CK1 = 1 ) {
			AA_1 := ""
			regexmatch(A_loopfield, RE1, AA_)
			If ( AA_1 != "" ) {
				If ( "是" = FoxVar("DelHeadSpace") )
				{
					regexmatch(A_loopfield, RE2, XX_)
					LV_Add("", XX_1, A_index)
				} else
					LV_Add("", A_loopfield, A_index)
			}
		}
	}
	eTime := A_TickCount - sTime
	SB_SetText("文件处理完毕:  耗时(ms): " . eTime . "  文件: " . SrcFilePath)
	NR := ""
return

Txt2eBook:   ; 依赖 SrcFilePath
	Gui, Submit, nohide
	if ( 0 = LV_GetCount() ) {
		TrayTip, 错误:, 请选择要处理的文件或拖入列表框
		return
	}
	If ( SrcFilePath = "" )
		SrcFilePath := FoxReg("上次文件路径")
	IfNotExist, %SrcFilePath%
	{
		Msgbox, 不存在文本文件:`n%SrcFilePath%
		return
	}
	If ( "是" = FoxVar("NoBOMHead") )
		FileEncoding, UTF-8-RAW
	else
		FileEncoding
	Fileread, NR, %SrcFilePath%
	sTime := A_TickCount
	SB_SetText("开始生成，请稍候...")

	LV_GetText(BookName, 1, 1) ; 书名
	LV_GetText(FoxCreator, 2, 1) ; 作者,默认:爱尔兰之狐
	FoxVar("BookCreator", FoxCreator)

	; 预测试生成保存路径，并提示用户
	TestPath = %FoxDir%\%bookname%.%EpubOutExt%
	IfNotExist, %TestPath%
	{
		fileappend, FoxTest, %TestPath%
		ifExist, %TestPath%
		{
			filedelete, %TestPath%
		} else {
			msgbox, 预测试生成文件失败: %TestPath%`n`n可能原因是书名不符合文件系统文件名规范，或该目录只读
			return
		}
	} else {
		msgbox, 文件已存在，请重命名原文件`n%TestPath%
		return
	}

	saveNowREList() ; 保存RE1表达式

	LinkID := 11 , LVNum := 3 , Toc := "" , Body := ""
	LV_GetText(NowTitle, LVNum, 1) , LV_GetText(NownTitleLine, LVNum, 2)
	TheFirstTitle := NownTitleLine

	ChapterCount := 0
	if ( EpubOutExt = "epub" or EpubOutExt = "mobi" )
		HeadAddSpace := "　　" , LineField := "<br />"
	else
		HeadAddSpace := "　　" , LineField := ""
	loop, parse, NR, `n, `r
	{
		NowLine := A_loopfield
		If ( CK3 = 1 ) {
			XX_1 := ""
			regexmatch(NowLine, RE2, XX_)
			NowLine := XX_1
		}

		If ( A_index = NownTitleLine ) { ; 标题行
			if ( ChapterCount > 0 )
				Body .= "`n</body" . ChapterCount . ">`n"
			++ ChapterCount
			Body .= "<title" . ChapterCount . ">" . NowTitle . "</title"  . ChapterCount . ">`n<body" . ChapterCount . ">`n"
			++LVNum
			LV_GetText(NowTitle, LVNum, 1) , LV_GetText(NownTitleLine, LVNum, 2)
		} else {
			If ( CK4 = 1 and NowLine != "" ) {
				Body .= HeadAddSpace . NowLine . LineField . "`n"
			} else {
				If ( NowLine = "" and "是" = FoxVar("DelBlankLine") )
					continue
				else
					Body .= NowLine . LineField . "`n"
			}
		}
	}
	Body .= "`n</body" . ChapterCount . ">`n"

	NR := ""
	if ( EpubOutExt = "epub" or EpubOutExt = "mobi" ) {
		if ( EpubOutExt = "epub" ) {
			FileInstall, zip.exe, zip.exe, 1
			If A_IsCompiled
				IfNotExist, zip.exe
					TrayTip, 错误:, zip.exe 释放失败`n可能是360之类的安全程序阻止
		}
		if ( EpubOutExt = "mobi" ) {
			FileInstall, kindlegen.exe, kindlegen.exe, 1
			If A_IsCompiled
				IfNotExist, kindlegen.exe
					TrayTip, 错误:, kindlegen.exe 释放失败`n可能是360之类的安全程序阻止
		}
		oEpub := new FoxEpub(BookName, FoxDir . "\temp_" . A_now)
		oEpub.BookCreator := FoxCreator
		CoverImgPath := FoxVar("CoverPicPath")
		if ( CoverImgPath != "" ) {
			oEpub.SetCover(CoverImgPath)
		}
		loop, %ChapterCount%
			oEpub.AddChapter(FoxXMLGetSec(Body, "title" . A_index), FoxXMLGetSec(Body, "body" . A_index))
		SB_SetText("1 / 2 耗时: " . eTime . "  网页生成完毕")
		oEpub.SaveTo(FoxDir . "\FoxIndex." . EpubOutExt)

		IfNotExist, %FoxDir%\FoxIndex.%EpubOutExt%
			TrayTip, 错误:, 生成FoxIndex.%EpubOutExt%文件失败
		Filemove, %FoxDir%\FoxIndex.%EpubOutExt%, %FoxDir%\%bookname%.%EpubOutExt%, 1
		IfNotExist, %FoxDir%\%bookname%.%EpubOutExt%
			TrayTip, 错误:, 重命名%EpubOutExt%文件失败
		/*
		If ( "是" = FoxVar("DelTmpFiles") ) {
			FileDelete, %FoxDir%\FoxIndex.opf
		}
		*/
		eTime := A_TickCount - sTime
		SB_SetText("2 / 2 耗时: " . eTime . "  " . EpubOutExt . "生成完毕: " . FoxDir . "\" . bookname . "." . EpubOutExt)
		EpubOutExt := ""
		return
	}
	if ( EpubOutExt = "umd" ) {
		FileInstall, UMD.dll, UMD.dll, 1
		If A_IsCompiled
			IfNotExist, UMD.dll
				TrayTip, 错误:, UMD.dll 释放失败`n可能是360之类的安全程序阻止
		oUMD := new FoxUMD(bookname)
		loop, %ChapterCount%
		{
			SB_SetText("生成UMD章节: " . A_index)
			originBody := FoxXMLGetSec(Body, "body" . A_index)
			StringReplace, originBody, originBody, `n, `r`n, A  ; 2015-11-2: alone 反馈在某些阅读器中换行不正确
			oUMD.AddChapter(FoxXMLGetSec(Body, "title" . A_index), originBody)
		}
		SB_SetText("保存UMD文件: " . FoxDir . "\" . bookname . "." . EpubOutExt)
		oUMD.SaveTo(FoxDir . "\" . bookname . "." . EpubOutExt)
	}
	if ( EpubOutExt = "pdf" ) {
		FileInstall, libhpdf.dll, libhpdf.dll, 1
		If A_IsCompiled
			IfNotExist, libhpdf.dll
				TrayTip, 错误:, libhpdf.dll 释放失败`n可能是360之类的安全程序阻止
		oPDF := new FoxPDF(bookname)
		loop, %ChapterCount%
		{
			SB_SetText("生成PDF章节: " . A_index)
			oPDF.AddTxtChapter(FoxXMLGetSec(Body, "body" . A_index), FoxXMLGetSec(Body, "title" . A_index))
		}
		SB_SetText("保存PDF文件: " . FoxDir . "\" . bookname . "." . EpubOutExt)
		oPDF.SaveTo(FoxDir . "\" . bookname . "." . EpubOutExt)
	}
	if ( EpubOutExt = "xml" )
		fileappend, %Body%, %FoxDir%\%bookname%.%EpubOutExt%

	eTime := A_TickCount - sTime
	IfNotExist, %FoxDir%\%bookname%.%EpubOutExt%
		TrayTip, 错误:, 生成%EpubOutExt%文件失败
	else
		SB_SetText("成功生成" . EpubOutExt . "文件: " . FoxDir . "\" . bookname . "." . EpubOutExt)
	EpubOutExt := ""
return


GuiClose:
GuiEscape:
	If A_IsCompiled
	{
		FileDelete, kindlegen.exe
		FileDelete, zip.exe
		FileDelete, UMD.dll
		FileDelete, libhpdf.dll
	}
	ExitApp
return

; -----备注:
^esc::reload
+esc::Edit
!esc::ExitApp
#Ifwinactive, ahk_class AutoHotkeyGUI
^a::   ; 全选
	GuiControl, Focus, FoxLV
	LV_Modify(0, "Select")
return
^Del::DeleteSelectList() ; 删除条目
^Up::LV_MoveRow()       ; 向上移动一行
^Down::LV_MoveRow(false)  ; 向下移动一行
^Insert:: LV_Insert(LV_GetNext(0, "Focused"), "", "00000", "XXXXX") ; 添加以条目
#Ifwinactive

DeleteSelectList()
{	; 删除 LV 列表中选中的行,注意要倒序来删哦，不然会有问题滴
	DeleteList := ""
	Loop { ; 获取选定的列表
		RowNumber := LV_GetNext(RowNumber)
		if ! RowNumber
			break
		DeleteList := RowNumber . ":" . DeleteList
	}
	stringtrimright, DeleteList, DeleteList, 1
	loop, parse, DeleteList, :
		LV_Delete(A_loopfield)
}

LV_MoveRow(moveup = true) { ; 从英文论坛弄来的函数，功能调整ListView中的条目顺序
   Loop, % (allr := LV_GetCount("Selected"))
      max := LV_GetNext(max)
   Loop, %allr% {
      cur := LV_GetNext(cur)
      If ((cur = 1 && moveup) || (max = LV_GetCount() && !moveup))
         Return
      Loop, % (ccnt := LV_GetCount("Col"))
         LV_GetText(col_%A_Index%, cur, A_Index)
      LV_Delete(cur), cur := moveup ? cur-1 : cur+1
      LV_Insert(cur, "Select Focus", col_1)
      Loop, %ccnt%
         LV_Modify(cur, "Col" A_Index, col_%A_Index%), col_%A_Index% := ""
   }
}

OpenURL(URL="http://linpinger.github.io?s=ExeTxt2eBook")
{
	IfExist, %A_ProgramFiles%\Internet Explorer\IEXPLORE.EXE
		run, %A_ProgramFiles%\Internet Explorer\IEXPLORE.EXE -new %URL%
	else
		run, %URL%
}

FoxReg(fKeyName="", fValue="狐说的x是读取模式")
{
	KeyPath := "Software\爱尔兰之狐\NormalTxt2Mobi"
	If ( fValue = "狐说的x是读取模式" ) {
		RegRead, xxx, HKCU, %KeyPath%, %fKeyName%
		If ErrorLevel
			return, -5
		else
			return, xxx
	} else {
		RegWrite, Reg_SZ, HKCU, %KeyPath%, %fKeyName%, %fValue%
		return, ErrorLevel
	}
}

FoxVar(iName="", iStr="get") ; iName 为static变量去掉s的部分, iStr 默认为get，也可为设置的值
{
	static sNoBOMHead , sCleanLV , sDelHeadSpace , sDelBlankLine , sDelTmpFiles
		, sBookCreator , sCoverPicPath
	If ( iStr = "get" )
		return, s%iName%
	else
		s%iName% := iStr
}

SettingMenu(Action="初始化设置", FoxCFGID="")
{
	CFGList =
	(join`n Ltrim
	NoBOMHead:不带BOM的UTF8编码:否
	CleanLV:拖入文件时清空列表:是
	DelHeadSpace:拖入处理标题时删除头部空格:否
	DelBlankLine:删除空白行:是
	DelTmpFiles:删除转换过程中的临时文件:是
	) ; 该顺序和ID相关，修改后需调整ID
	Stringsplit, LL_, CFGList, `n

	If ( Action = "初始化设置" ) {
		loop, parse, CFGList, `n
		{
			FF_1 := "" , FF_2 := "" , FF_3 := ""
			stringsplit, FF_, A_loopfield, :
			NowVarName := FF_1 , NowCNName := FF_2 , NowDefaultValue := FF_3
			is%NowVarName% := FoxReg(NowCNName) ;---
			If ( is%NowVarName% = "是" or is%NowVarName% = "否" )
				FoxVar(NowVarName, is%NowVarName%)
			else	; 默认值
				FoxVar(NowVarName, NowDefaultValue)
		}
	}
	If ( Action = "还原为默认设置" ) {
		loop, parse, CFGList, `n
		{
			FF_1 := "" , FF_2 := "" , FF_3 := ""
			stringsplit, FF_, A_loopfield, :
			FoxVar(FF_1, FF_3) , FoxReg(FF_2, FF_3) ;---
			If ( "是" = FF_3 )
				Menu, sMenu, Check, %FF_2%
			else
				Menu, sMenu, UnCheck, %FF_2%
		}
		SB_SetText("所有设置已还原")
	}
	If ( Action = "添加菜单" ) {
		FF_1 := "" , FF_2 := "" , FF_3 := ""
		stringsplit, FF_, LL_%FoxCFGID%, :
		Menu, sMenu, Add, %FF_2%, FoxMenuAct
		If ( "是" = FoxVar(FF_1) )
			Menu, sMenu, Check, %FF_2%
		else
			Menu, sMenu, UnCheck, %FF_2%
	}
	If ( Action = "切换按钮" ) {
		FF_1 := "" , FF_2 := "" , FF_3 := ""
		stringsplit, FF_, LL_%FoxCFGID%, :
		If ( "是" = FoxVar(FF_1) ) {
			FoxVar(FF_1, "否") , FoxReg(FF_2, "否")
			Menu, sMenu, UnCheck, %FF_2%
			SB_SetText("已取消: " . FF_2)
		} else {
			FoxVar(FF_1, "是") , FoxReg(FF_2, "是")
			Menu, sMenu, Check, %FF_2%
			SB_SetText("已选中: " . FF_2)
		}
	}

}

FoxXMLGetSec(byref SrcStr, LableName="Title55")
{
	RegExMatch(SrcStr, "smUi)<" . LableName . ">(.*)</" . LableName . ">", out_)
	return, out_1
}

FoxInput(wParam, lParam, msg, hwnd)  ; 在特殊控件按下特殊按键的反应
{
	If ( A_GuiControl = "RE1" and wParam = 13 )
		gosub, ReDragFile
}

saveNowREList() ; 保存RE表达式
{
	global FoxRElist, FoxRECount
	GuiControlGet, RE1

	; 过滤相同并重新排序列表
	nREList := RE1 . "`n"
	FoxRECount := 1
	FoxReg("正则表达式_" . FoxRECount, RE1) ; 写入注册表
	loop, parse, FoxRElist, `n, `r
	{
		If ( A_loopField = "" )
			Continue

		If ( A_loopfield != RE1 ) {
			++FoxRECount
			nREList .= A_loopfield . "`n"
			FoxReg("正则表达式_" . FoxRECount, A_loopfield) ; 写入注册表
		}
	}
	FoxReg("正则表达式计数", FoxRECount)
	FoxRElist := nREList
	GuiControl, , RE1, `n%nREList%
	GuiControl, choose, RE1, 1
}

#include <FoxEpub_Class>
#include <FoxPDF_Class>
#include <FoxUMD_Class>
