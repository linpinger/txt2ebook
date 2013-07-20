Txt2eBook
=========

声明: 本程序调用了 amazon 的 kindlegen/mobigen，code.google上的umdbuilder, zip.exe, libhpdf.dll，版权归各被调用程序及库的所有者

功能: 将文本文件转换为各种格式的电子书:mobi(Kindel电子书),Epub(不包含字体),pdf(6寸),umd(手机电子书) 

爱尔兰之狐:

缘起: 基于txt2mobi程序，添加其他格式支持，扩大使用范围

原理: TXT -> UTF-8 HTML/NCX/OPF ->(kindlegen/mobigen) Mobi / Epub

下载:

程序(单独处理txt, 生成目录): [Txt2eBook.exe](https://raw.github.com/linpinger/Txt2eBook/master/Txt2eBook.exe)

源代码(单独处理txt, 生成目录): [Txt2eBook.ahkL](Txt2eBook.ahkL)

本程序从AnsiTxt2Mobi升级而来


