# 【概要】
hiki formatで書かれた文章を，latex formatに変換する
# 【置き場所】
- [rubygems](http://rubygems.org/gems/hiki2latex)
- [Github](https://github.com/daddygongon/hiki2latex)

# 【使用法】
Use as a gem library:
```ruby
    require 'hiki2latex'
    
    puts HikiDoc.to_latex(File.read(ARGV[0]),{:level=>@level,:listings=>@listings})
```

or as a command line tool:

<dl>
<dt>Usage</dt><dd> hiki2latex [options] FILE</dd>
</dl>

```
> hiki2latex --pre PRICM_preamble.tex --post biblio.tex -p test.hiki > test.tex
> hiki2latex --listings --post post.tex -p ./test.hiki > test.tex
```

| option | operation|
|:----|:----|
|    -v, --version     |           show program Version.|
|    -l, --level VALUE |               set Level for output section.|
|    -p, --plain FILE  |               make Plain document.|
|    -b, --bare FILE   |               make Bare document.|
|        --head FILE   |               put headers of maketitle file.|
|        --pre FILE    |               put preamble file.|
|        --post FILE   |               put post file.|
|        --listings    |               use listings.sty for preformat with style.|


- より詳細な使用法は，nishitani0のhiki2latex_gemizingにある．
- 西谷研の内部で利用するときに特化したマニュアルはnishitani0のhiki2latex_manual．

## sample
幾つかのサンプルを以下に示す．
### caption:hiki2latexにより作成されたpdfファイトとその元ネタ．

|ソース(hiki表示)|pdf(latex変換後)|
|:----|:----|
|[Shunkuntype](Shunkuntype)のレポート|
|[LPSO15研究会の例](LPSO15_fall_meeting_abst)|{{attach_anchor(LPSO_abst.pdf)}}|
|[中間発表hand out例](AbstSample)|{{attach_anchor(AbstSample.pdf)}}|
|[使っているformat集](DocumentFormatter_format_examples)|


# 【仕様】
1. hikdoc.rbにwrap
1. header部を独立して提供
1. author, titleはheadに手を加えて提供
1. 図はattach_viewを変換
1. 表はそのまま表示
  1. tableのmulti対応
1. captionはheaderで提供
1. citeは対応しない．
1. graph, tableは[h]で提供．

# 【具体的な使用例rakefile】
具体的な使用例として[Shunkuntype_report](Shunkuntype_reportd)を作成した時のRakefile.rbを示す．何度も書き直す時は，このようにして自動化すべき．
```ruby
task :shunkuntype do
  dir = '~/Sites/nishitani0/Internal/data/text/'
  targets =["Shunkuntype_manual","Shunkuntype_gemizing","TouchTyping_Coding"]
  targets.each{|file|
    p command= "rm -f #{file}.tex"
    system command
    p command= "hiki2latex -l 2 --listings -b #{dir}#{file} > #{file}.tex"
    system command
  }
  file="Shunkuntype_report"
  p command= "rm -f #{file}.tex"
#  p command= "hiki2latex --listings --head head.tex --post post.tex -p #{dir}#{file} > #{file}.tex"
  p command= "hiki2latex --listings --post post.tex -p #{dir}#{file} > #{file}.tex"
  system command

  p command = "open #{file}.tex"
  system command
  exit
end
```
本文(Shunkuntype_report.tex)と付録(targets.texs)がある．付録は'-l 2 -b'によってsubsectionからのtitle levelにしてbare modeで作っている．post.texにpostで付け加えるtex部を指定して，appendixをつけている．

# 【code documents】
[rdoc](http://nishitani0.kwansei.ac.jp/~bob/nishitani0/rdocs/hiki2latex/index.html)に置いといたけど，ruby gemsやgithubに置けば不要となる．
# 【変更履歴，内容】
変更履歴，内容を表に示す．15/8月期で基本開発．16/2月期にgem化．
## caption:変更履歴，内容

|memo |date|hiki|
|:----|:----|:----|
|hikidoc.rbからhiki2latex.rb|15/8/4|![](hiki2latex_init)|
|hiki2latex.rbひな形作成|15/8/5|
|@fをStringIOからStringへ|15/8/5|
|graph+caption|15/8/6|![](LPSO15_fall_meeting_abst)|
|math|15/8/7| ![](hiki2latex_math)|
|table| 15/8/8| ![](hiki2latex_table)|
|under_score| 15/8/11 | ![](hiki2latex_math)|
|gem化| 16/2/13 | ![](hiki2latex_gemizing)|
|listings| 16/2/16 | ![](hiki2latex_listings)|


# 【開発メモ】
## 制限事項
- title中へuriの埋め込みが未対応．
  - uriのverbがlatexのtitle内で使えないため．
## 【 保留項目】
1. includegraphicsの自動提供
  1. hikiに置かれているgraphは劣化版なんでそれをいじるのはあまり筋がよろしくない．
  1. epsならできるかも．hikeのattach_viewでサイズをどういじっているか．．．
1. underbar(_)がlatexでは全て引っかかる．escapeする？-> 対応済み ![](hiki2latex_math)
  1. snake表記はrubyではfile名や変数名に頻繁に使われるので対処が必要かも．

## 【math】
＄＄での変換がうまくいかない．
```
hikiconf.rb
```
での設定を
```
#@style           = 'default'
@style           = 'math'
```
としたらhikiからエラーは出なくなったが．まだまだ．．．．

## 【user def】
```
\def\Vec#1{\mbox{\boldmath $#1$}}
```
はpreambleに置くことが推奨されているが，実際は，使用するまでに定義すればいい．preambleをいじるようになるころには，latexについての十分な経験があると思われるので，hiki2latexではいじらない．ちょこっと必要ならhiki本文中に埋め込むべし．今の仕様では，
```ruby
  def initialize(file_name)
    @buf = ""
    @buf << HEADER+"\n"
    @buf <<  "\\begin{document}\n"
    @buf <<  HikiDoc.to_latex(file_name)+"\n"
    @buf <<  REFERENCE+"\n"
    @buf << "\\end{document}\n"
  end

  def display
    @buf
  end
```
とするのが正しそうなので，無理に入れていない．将来はpreambleを保持するような拡張機能(option)が必要かもしれない．それは，「原典一つ主義」で，hikiを原典とするか，latexを原典とするかの選択が迫られたとき．
  - 追記(2015/02/17) いい考察だ．解はでてないが今はhiki2latexに埋め込んで，それらの仕様をできるだけ吸収しようとしている．
