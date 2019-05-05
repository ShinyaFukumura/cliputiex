# cliputiex (macOS clipboard "Puti" extention)

## What's this? / アプリ概要
This application is a macOS clipboard extention for IT infrastructure engineers and IT operators.  
This application has only three functions.  
When you copied any text, 
1. trim leading and trailing whitespace from copied text,
2. erase a leading charactor "#" or "$" from copied text,
3. append "\n" at the end of copied text.

macOSでインフラ屋さん（主に自分）がコマンド行のコピペでイライラしないために作ったアプリです。  
何がイライラするかというと先頭の"#"を含まないように一行一行コピペして実行しないといけないこと。  
エディタ使って先頭文字を一括除去する方法など手段はありますが、個人的にはコピーした後すぐにペーストしたい。  
そんなアプリないかなと思って、軽く探してみたのですがパッと見つか利ませんでした。 　
そこで、勉強も兼ねて初めてSwiftアプリを作りました。  
機能はシンプルに3つのみ。
1. コピーした文字列から先頭と末尾の空白を除去する。
2. コピーした文字列の先頭文字が"#"か"$"の場合、先頭文字を除去する。
3. コピーした文字列の最後に改行コード"\n"を付与する。

### example 1 / 利用例1

```copied
# rpm -aq > /tmp/before_yum_update.txt      
      # yum -y update
#      yum -y install wget  
#              rpm -aq > /tmp/after_yum_update.txt
# exit
```

```pasted
rpm -aq > /tmp/before_yum_update.txt
yum -y update
yum -y install wget
rpm -aq > /tmp/after_yum_update.txt
exit

```

### example 2 / 利用例2

```copied
$ cp a.txt b.txt        
    $ echo "foo" >>     a.txt   
$ diff a.txt b.txt
        abcabcabcabc     
```

```pasted
cp a.txt b.txt
echo "foo" >>     a.txt
diff a.txt b.txt
abcabcabcabc

```

## Specification / 仕様
This application polls the system clipboard for changing text.  
Polling interval is 1 seconds.

本アプリはクリップボードの変化を1秒間隔でチェックします。  
macOSではクリップボードの変化を通知する仕組みが無いっぽい・・・。

## Dependency / 開発環境
- OS: macOS Mojave 10.14.4
- IDE: Xcode 10.2.1
- Lang: Swift 5.0

## System Requirements / システム要件
- OS: macOS Mojave 10.14.4
I didn't check other macOS version.  
When you try, please feedback your macOS version.  
自分のmacOSでしか動作確認していません。  
是非フィードバックください。

## How to install / インストール方法
Copy the application file "cliputiex" to any directory.  
"cliputiex"ファイルを任意のディレクトリにコピーしてください。

## Usage / 実行方法
Double click the application file "cliputiex".  
When you quit this application, operate cliputiex -> Q
uit on menubar.  
When you don't use this application, operate cliputiex -> Available on menubar.  
"cliputiex"ファイルをダブルクリックしてください。  
終了する際はメニューバーから cliputiex -> Quit してください。  
一時的に利用を停止する場合はメニューバーから cliputiex -> Available してください。

## Want to do / 実装したいこと
- ~~Implement on-off mode.~~
    + ~~on: This application work.~~
    + ~~off: This application does not work.~~
- Implement to change polling inverval.
- ~~Implement to prevent double startup of this application.~~

## Licence / ライセンス
This software is released under the MIT License, see LICENSE.

## Acknowledgment / 謝辞
This application uses [PasteboardWatcher.swift](https://gist.github.com/Daemon-Devarshi/13efd24f027a775ee862) created by Devarshi Kulshreshtha.  
Devarshi Kulshreshtha 様が作成された [PasteboardWatcher.swift](https://gist.github.com/Daemon-Devarshi/13efd24f027a775ee862) を改編利用しております。

## References / 参照
[Menus and Popovers in Menu Bar Apps for macOS](https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos)  
[ステータスバーに常駐するアプリケーション](https://qiita.com/arthur87/items/1998541004853d171088)  
[Menus and Popovers in Menu Bar Apps for macOS](https://www.raywenderlich.com/450-menus-and-popovers-in-menu-bar-apps-for-macos)