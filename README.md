Txt2eBook(文本转电子书:mobi,epub,pdf,umd)
-----------------------------------------
**声明:** 本程序调用了 amazon 的 kindlegen/mobigen，code.google上的umdbuilder, 还有 zip.exe, libhpdf.dll, Freeimage.dll等，版权归各被调用程序及库的所有者

**名称:** Txt2eBook  

**功能:** 将文本文件转换为各种格式的电子书:mobi(Kindel电子书),Epub(不包含字体),pdf(6寸),umd(手机电子书)

**作者:** 爱尔兰之狐(linpinger)

**邮箱:** [linpinger@gmail.com](mailto:linpinger@gmail.com)

**主页:** <http://linpinger.github.io?s=Atc_Txt2eBook>

**缘起:** 基于txt2mobi程序，添加其他格式支持，扩大使用范围

**原理:** TXT -\> UTF-8 HTML/NCX/OPF -\>(kindlegen/mobigen) Mobi / Epub

**下载:**
-   程序(单独处理txt, 生成目录): [Txt2eBook.exe](../../releases/download/Txt2eBook/Txt2eBook.exe)
-   源代码(单独处理txt, 生成目录): [Txt2eBook.ahkL](Txt2eBook.ahkL)

本程序从[AnsiTxt2Mobi](../mobi/AnsiTxt2Mobi.html)升级而来

**截图:**
 ![](Txt2eBook.png)

**最简单的使用方法:**将文本文件拖动到列表框(窗口中最大的那个框)中, 按顶部右边的 Epub / Mobi / PDF 菜单，然后就会生成Epub/mobi/pdf文件(有没有目录得看你的Txt的标题是不是 第xxx 章 这样的类型)

**复杂的使用方法:**见: [AnsiTxt2Mobi](../mobi/AnsiTxt2Mobi.html)

**Linux下使用方法:**使用wine可以运行本程序。注意使用选择文件按钮选择txt文件,umd,mobi文件都可以正常生成，若当前目录下存在 lantinghei.ttf，就可以生成PDF文件，epub文件因为两次调用zip.exe，可能由于权限问题，造成第一次生成的epub文件修改不了，导致主要文件添加失败，不过可以在.wine目录下的c驱动目录中找到临时目录，调用linux下的zip重新生成epub即可

**可能的保存生成电子书的路径:**

-   程序所在目录
-   文件所在目录
-   C:\\
-   C:\\etc\\

**更新日志:**

-   2014-04-30: 修正: 默认优先以文件名做书名，如果为数字，选一行为书名，若为空，为FoxBook
-   2013-03-09: 添加: 选择文件按钮，便于在无法拖动的场合选择文件,多谢atuo
-   2013-02-27: 修正: 提示行修正,多谢Andy Wu
-   2013-02-18: 修正: Mac下解析br标签错误，替换为br闭合标签,多谢Shawn Wu 
-   2013-07-15: 修正: GUI可缩放大小，预检测生成文件可能性
-   2013-06-22: 修正: Mobi/Epub无法修改作者名
-   2013-05-08: 修正: 取消默认置顶，增加GUI宽度以适应win7，可在拖入文件后修改正则，回车即可，避免再次拖入文件
-   2013-05-07: 修正: mobigen生成的mobi格式在Kindle PaperWhite上，跳转目录显示为乱码，需使用kindlegen，多谢:那个小谁 永远的冥王星 帮助测试
-   2013-04-19: 小修改: 生成菜单靠右，添加UMD到主菜单栏
-   2013-03-31: 从AnsiTxt2Mobi中分离出来，扩大使用范围，修改正则表达式
-   2013-03-08: 部分重写: 加入生成Epub格式选项，可能导致删除临时文件选项无效, 多谢 colin 的留言(其实有点懒，不怎么想更新这个程序了，其实我写的另一个工具FoxBook已有epub支持，甚至umd,chm等)

