# title:hiki2yardによる数値計算資料の作成システム
# author:情報科学科 西谷研究室 1234 西谷滋人

# 目的
hikiフォーマット文書をlatexフォーマットに変換するhiki2latex[1]をもちいて中間発表のabstract資料を作成する手順を紹介する．

# インストール
最初に，作業を自動化するhiki2yard[2]をrubygemsからinstallする．terminal上で，
```
gem install hiki2yaml
```
によって環境を構築するCUIがinstallされる．
```
hiki2yard --version
```
によってversionが表示されれば，正常にinstallがなされていることが確認できる．

# 環境構築
terminal上で
```
hiki2yard --init
```
によって，必要となるファイルが自動的に配置される．指示に従って，hogehoge.gemspecを
手動で修正する必要がある．さらに，
```
bundle update
```
によって，必要なgem filesがinstallされる．

# directory構成と各ファイルの意味
次にdirectory構成を示す．これはbundle gem -bによって生成される標準gem構築環境に修正を加えた構成となる．
```
bob% tree .
.
├── CODE_OF_CONDUCT.md
├── Gemfile
├── Gemfile.lock
├── LICENSE.txt
├── README.md
├── Rakefile
├── bin
├── doc
├── exe
├── hiki2yard.gemspec
├── hiki2yard.wiki
├── hikis
│   ├── README_en.hiki
│   ├── handout_sample.hiki
...
├── latexes
│   ├── handout_pre.tex
├── lib
├── pkg
└── spec
```
hikisにtargetとなるfileをhiki構文で作る．Rakefileに必要なtaskが登録されている．latexesには現在のところ，中間発表のhandoutを生成するpre-formatのtexが置かれている．
```
rake latex
```
によって
```
hiki2latex --pre latexes/handout_pre.tex hikis/handout_sample.hiki > latexes/handout_sample.tex
```
が起動され，latexes上にtargetのtex format文書が生成される．この後，自動的に起動されるmacのapplicationであるTeXShop上でcommand-tを押下することで，latexからpdfへ変換を行い，中間発表のabstractを作成する．

# 個別の準備
- 各人は自分でhikis/hogehoge.hikiファイルを生成する
- Rakefileの:latexタスクにあるtarget変数を変更する
後は，マニュアルに従ってpdf文書を作成できるはずである．質問がある場合は早めにね．

# 参考資料
1. [hiki2latex](https://rubygems.org/gems/hiki2latex), 2016/08/11アクセス．
1. [sakibts/hiki2yard](https://github.com/sakibts/hiki2yard), 2016/08/11アクセス．
