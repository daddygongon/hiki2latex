# 【概要】
hikiで書いたのを中間発表の予稿集用に変換するマニュアル．
# 【下準備】
1. yahataProjectをinstall
1. rake initを実行．passwordを聞かれたときはdonkeyかnishitaniに知らせる
1. setenvでpathを設定
# 【手順】
1. hikiにGraduate_handout原稿を作成
1. 作業用のdirectoryを作成
1. そこで，hiki2abst.rb ~/Sites/hiki-1.0/data/text/Graduate_handout > Graduate_handout.tex
1. open Graduate_handout.tex
1. command-Tでpdfへ変換．

# 【graph作成手順】
## hiki
1. 適当なサイズに調整したファイルを添付ファイルとしてUpLoad
- ImageMagickがinstallされているとして，convert A.png -scale 50% B.png
## latex directory
1. hikiでファイルを選択してDownLoad
1. 作業用のlatex directoryへ移す．
1. ebb B.pngでB.bbを作成．
1. TeXShopでcompileすればいけるはず．

# 【TeXShopの設定】
## ファイルが文字化け
- 「設定」->書類->エンコーディング　Unicode(UTF-8)
- 　同じタグの「設定プロファイル」->　pTeX(ptex2pdf)を選択
- TeXShopを再起動
- compileすればいけるはず．
## compileうまくいかないとき．
- *.auxファイルを消去して，再compile．
